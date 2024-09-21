//
//  ApiService.swift
//  Homely
//
//  Created by Pedro Belfort on 21.09.24.
//

import Foundation

protocol EndpointProtocol {
    var path: String { get }
    func url(for environment: Environment) -> String
}

protocol HTTPServiceProtocol {
    associatedtype E: EndpointProtocol
    
    func get<T: Decodable>(_ endpoint: E) async throws -> T
    func post<T: Decodable>(_ endpoint: E, body: [String: Any]) async throws -> T
}

class HTTPService<E: EndpointProtocol> : HTTPServiceProtocol {
    
    private let environment: Environment
    private let session: URLSession
    private let tokenProvider: TokenProviderProtocol
    
    init(environment: Environment, tokenProvider: TokenProviderProtocol) {
        self.environment = environment
        self.session = HTTPService.createSession()
        self.tokenProvider = tokenProvider
    }
    
    private static func createSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        return URLSession(configuration: config)
    }
    
    /**
     Makes a GET request to the given endpoint and decodes the response into the specified type.
     
     - Parameters:
     - endpoint: The endpoint relative to the base URL.
     - Returns: A decoded object of type `T` if the request is successful.
     - Throws:
     - `APIError.invalidURL` if the endpoint is not valid.
     - `APIError.invalidResponse` if the response is not a valid HTTP response.
     - `APIError.clientError(Int)` for 4xx status codes.
     - `APIError.serverError(Int)` for 5xx status codes.
     - Other possible errors related to the network or JSON decoding.
     */
    func get<T: Decodable>(_ endpoint: E) async throws -> T {
        return try await executeRequest(endpoint, method: "GET")
    }
    
    /**
     Makes a POST request to the given endpoint with the provided JSON body and decodes the response.
     
     - Parameters:
     - endpoint: The endpoint relative to the base URL.
     - body: A dictionary representing the JSON body to be sent in the request.
     - Returns: A decoded object of type `T` if the request is successful.
     - Throws:
     - `APIError.invalidURL` if the endpoint is not valid.
     - `APIError.invalidResponse` if the response is not a valid HTTP response.
     - `APIError.clientError(Int)` for 4xx status codes.
     - `APIError.serverError(Int)` for 5xx status codes.
     - Other possible errors related to the network or JSON decoding.
     */
    func post<T: Decodable>(_ endpoint: E, body: [String: Any]) async throws -> T {
        let bodyData = try encodeToJSON(body)
        return try await executeRequest(endpoint, method: "POST", body: bodyData)
    }
    
}


// MARK: - Helper Methods Extension

private extension HTTPService {
    func createRequest(endpoint: E, method: String, body: Data? = nil) throws -> URLRequest {
        guard let url = URL(string: endpoint.url(for: environment)) else {
            logError("General API error: Invalid URL")
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add the JWT token to the Authorization header if available
        if let token = tokenProvider.jwtToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = body
        }
        return request
    }
    
    func executeRequest<T: Decodable>(_ endpoint: E, method: String, body: Data? = nil) async throws -> T {
        do {
            let request = try createRequest(endpoint: endpoint, method: method, body: body)
            let (data, response) = try await session.data(for: request)
            
            _ = try validateResponse(response, endpoint: endpoint)
            return try decodeResponse(data)
        } catch let error as APIError {
            // Attempt to refresh token and retry the original request
            let retryRequest = try createRequest(endpoint: endpoint, method: method, body: body)
            return try await handleTokenExpiration(error: error, originalRequest: retryRequest, endpoint: endpoint, body: body)
        }
    }
    
    /**
     Validates the HTTP response to ensure it has a successful status code (2xx).
     
     This method also handles other HTTP status code ranges, throwing appropriate errors for client and server issues.
     
     - Parameter response: The `URLResponse` object to validate.
     - Returns: The HTTP response if it is valid.
     - Throws:
     - `APIError.invalidResponse` if the response is not an `HTTPURLResponse`.
     - `APIError.clientError(Int)` if the response status is in the 4xx range.
     - `APIError.serverError(Int)` if the response status is in the 5xx range.
     - `APIError.unexpectedStatusCode(Int)` if the status code is outside expected ranges.
     */
    func validateResponse(_ response: URLResponse?, endpoint: E? = nil) throws -> HTTPURLResponse {
        guard let httpResponse = response as? HTTPURLResponse else {
            logError("Invalid response received.", endpoint: endpoint)
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return httpResponse
        case 400...499:
            logError("Client error: \(httpResponse.statusCode)", endpoint: endpoint)
            throw APIError.clientError(httpResponse.statusCode)
        case 500...599:
            logError("Server error: \(httpResponse.statusCode)", endpoint: endpoint)
            throw APIError.serverError(httpResponse.statusCode)
        default:
            logError("Unexpected status code: \(httpResponse.statusCode)", endpoint: endpoint)
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
    
    /**
     Handles the token expiration scenario. If the token is expired, tries to refresh it, updates the token provider, and retries the original request.
     
     - Parameters:
     - originalRequest: The original request that failed due to token expiration.
     - endpoint: The endpoint of the failed request.
     - body: The body data of the original request.
     - Returns: A decoded object of type `T` if the retry is successful.
     - Throws: An error if the token refresh fails or the retry fails.
     */
    func handleTokenExpiration<T: Decodable>(
        error: APIError,
        originalRequest: URLRequest,
        endpoint: E,
        body: Data?
    ) async throws -> T {
        guard case .unauthorized = error else {
            throw error
        }
        
        // Attempt to refresh token
        let newToken = try await tokenProvider.refreshToken()
        logInfo("JWT Token refreshed! \(newToken)")
        
        // Retry the original request with the new token
        var retryRequest = originalRequest
        retryRequest.setValue("Bearer \(newToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await session.data(for: retryRequest)
        _ = try validateResponse(response, endpoint: endpoint)
        return try decodeResponse(data)
    }
    
    func encodeToJSON(_ body: [String: Any]) throws -> Data {
        do {
            return try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            logError("Failed to encode JSON: \(error.localizedDescription)")
            throw APIError.encodingFailed
        }
    }
    
    func decodeResponse<T: Decodable>(_ data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    
    func logError(_ message: String, endpoint: E? = nil) {
        #if DEBUG
        if let endpoint = endpoint {
            print("Path: \(endpoint.path)\nAPI Error: \(message)")
        } else {
            print("API Error: \(message)")
        }
        #endif
    }
    
    func logInfo(_ message: String, endpoint: E? = nil) {
        #if DEBUG
        if let endpoint = endpoint {
            print("Path: \(endpoint.path)\nInfo: \(message)")
        } else {
            print("Info: \(message)")
        }
        #endif
    }
}
