//
//  ApiService.swift
//  Homely
//
//  Created by Pedro Belfort on 21.09.24.
//

import Foundation

protocol HTTPClientServiceProtocol {
    func get<T: Decodable>(_ endpoint: String) async throws -> T
    func post<T: Decodable>(_ endpoint: String, body: [String: Any]) async throws -> T
}

class HTTPClientService : HTTPClientServiceProtocol {
    private let baseUrl: String
    private let session: URLSession
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
        self.session = HTTPClientService.createSession()
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
    func get<T: Decodable>(_ endpoint: String) async throws -> T {
        let request = try createRequest(endpoint: endpoint, method: "GET")
        let (data, response) = try await session.data(for: request)
        
        // This will throw an appropriate error based on the response
        _ = try validateResponse(response)
        return try decodeResponse(data)
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
    func post<T: Decodable>(_ endpoint: String, body: [String: Any]) async throws -> T {
        let bodyData = try JSONSerialization.data(withJSONObject: body)
        let request = try createRequest(endpoint: endpoint, method: "POST", body: bodyData)
        let (data, response) = try await session.data(for: request)
        
        // This will throw an appropriate error based on the response
        _ = try validateResponse(response)
        return try decodeResponse(data)
    }
    
}


// MARK: - Helper Methods Extension

private extension HTTPClientService {
    func createRequest(endpoint: String, method: String, body: Data? = nil) throws -> URLRequest {
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            logError("General API error: Invalid URL")
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let body = body {
            request.httpBody = body
        }
        return request
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
    func validateResponse(_ response: URLResponse?) throws -> HTTPURLResponse {
        guard let httpResponse = response as? HTTPURLResponse else {
            logError("Invalid response received.")
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return httpResponse
        case 400...499:
            logError("Client error: \(httpResponse.statusCode)")
            throw APIError.clientError(httpResponse.statusCode)
        case 500...599:
            logError("Server error: \(httpResponse.statusCode)")
            throw APIError.serverError(httpResponse.statusCode)
        default:
            logError("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
    
    func decodeResponse<T: Decodable>(_ data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    
    func logError(_ message: String) {
        #if DEBUG
        print("API Error: \(message)")
        #endif
    }
}
