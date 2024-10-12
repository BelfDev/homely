//
//  HTTPService.swift
//  Homely
//
//  Created by Pedro Belfort on 21.09.24.
//

import Foundation

protocol HTTPServiceProtocol {
    associatedtype E: EndpointProtocol
    
    func get<T: Decodable>(_ endpoint: E) async throws -> T
    func post<T: Decodable, B: Encodable>(_ endpoint: E, body: B) async throws -> T
    func put<T: Decodable, B: Encodable>(_ endpoint: E, body: B) async throws -> T
    func patch<T: Decodable, B: Encodable>(_ endpoint: E, body: B) async throws -> T
    func delete<T: Decodable>(_ endpoint: E) async throws -> T
}

class HTTPService<E: EndpointProtocol> : HTTPServiceProtocol {
    
    private let environment: EnvConfig
    private let session: URLSession
    private let tokenProvider: TokenProviderProtocol
    private let maxRetryCount: Int
    private let retryDelay: TimeInterval
    private let requestManager: RequestManager<E>
    
    init(environment: EnvConfig, tokenProvider: TokenProviderProtocol, maxRetryCount: Int = 5, retryDelay: TimeInterval = 3.0) {
        self.environment = environment
        self.session = HTTPService.createSession()
        self.tokenProvider = tokenProvider
        self.maxRetryCount = maxRetryCount
        self.retryDelay = retryDelay
        self.requestManager = RequestManager<E>()
    }
    
    private static func createSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        config.timeoutIntervalForResource = 30.0
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
        return try await initiateHTTPRequest(endpoint, method: "GET")
    }
    
    /**
     Makes a POST request to the given endpoint with the provided `Encodable` body and decodes the response.
     
     - Parameters:
     - endpoint: The endpoint relative to the base URL.
     - body: An object conforming to `Encodable` to send as JSON
     - Returns: A decoded object of type `T` if the request is successful.
     - Throws:
     - `APIError.invalidURL` if the endpoint is not valid.
     - `APIError.invalidResponse` if the response is not a valid HTTP response.
     - `APIError.clientError(Int)` for 4xx status codes.
     - `APIError.serverError(Int)` for 5xx status codes.
     - Other possible errors related to the network or JSON decoding.
     */
    func post<T: Decodable, B: Encodable>(_ endpoint: E, body: B) async throws -> T {
        let bodyData = try encodeToJSON(body)
        return try await initiateHTTPRequest(endpoint, method: "POST", body: bodyData)
    }
    
    /**
     Makes a PUT request to the given endpoint with the provided `Encodable` body and decodes the response.
     
     - Parameters:
     - endpoint: The endpoint relative to the base URL.
     - body: An object conforming to `Encodable` to send as JSON
     - Returns: A decoded object of type `T` if the request is successful.
     - Throws:
     - `APIError.invalidURL` if the endpoint is not valid.
     - `APIError.invalidResponse` if the response is not a valid HTTP response.
     - `APIError.clientError(Int)` for 4xx status codes.
     - `APIError.serverError(Int)` for 5xx status codes.
     - Other possible errors related to the network or JSON decoding.
     */
    func put<T: Decodable, B: Encodable>(_ endpoint: E, body: B) async throws -> T {
        let bodyData = try encodeToJSON(body)
        return try await initiateHTTPRequest(endpoint, method: "PUT", body: bodyData)
    }
    
    /**
     Makes a PATCH request to the given endpoint with the provided `Encodable` body and decodes the response.
     
     - Parameters:
     - endpoint: The endpoint relative to the base URL.
     - body: An object conforming to `Encodable` to send as JSON
     - Returns: A decoded object of type `T` if the request is successful.
     - Throws:
     - `APIError.invalidURL` if the endpoint is not valid.
     - `APIError.invalidResponse` if the response is not a valid HTTP response.
     - `APIError.clientError(Int)` for 4xx status codes.
     - `APIError.serverError(Int)` for 5xx status codes.
     - Other possible errors related to the network or JSON decoding.
     */
    func patch<T: Decodable, B: Encodable>(_ endpoint: E, body: B) async throws -> T {
        let bodyData = try encodeToJSON(body)
        return try await initiateHTTPRequest(endpoint, method: "PATCH", body: bodyData)
    }
    
    /**
     Makes a DELETE request to the given endpoint and decodes the response.
     
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
    func delete<T: Decodable>(_ endpoint: E) async throws -> T {
        return try await initiateHTTPRequest(endpoint, method: "DELETE")
    }
}

// MARK: - Request Execution

private extension HTTPService {
    
    /**
     Initiates an HTTP request while ensuring no duplicate requests for the same endpoint are made concurrently.
     
     - Parameters:
     - endpoint: The endpoint to request.
     - method: The HTTP method to use (GET, POST, etc.).
     - body: Optional body data to send with the request, if applicable.
     
     - Returns: A decoded object of type `T` if the request is successful.
     
     - Throws:
     - `APIError.duplicateRequest` if a request for the same endpoint is already in progress.
     - `APIError` if any network or API error occurs during the request.
     */
    func initiateHTTPRequest<T: Decodable>(_ endpoint: E, method: String, body: Data? = nil) async throws -> T {
        guard await requestManager.isRequestOngoing(for: endpoint) == false else {
            logInfo("Request is already ongoing for \(endpoint.path)")
            throw APIError.duplicateRequest
        }
        
        await requestManager.setRequestOngoing(true, for: endpoint)
        
        do {
            let result: T = try await executeRequestWithRetry(endpoint, method: method, body: body)
            await requestManager.setRequestOngoing(false, for: endpoint)
            return result
        } catch {
            await requestManager.setRequestOngoing(false, for: endpoint)
            throw error
        }
    }
    
    /**
     Executes an HTTP request with retry logic for handling transient errors.
     
     - Throws:
     - `APIError` in case of any network or API error.
     - If the error is retryable, the method retries the request up to `maxRetryCount` times.
     */
    func executeRequestWithRetry<T: Decodable>(_ endpoint: E, method: String, body: Data? = nil) async throws -> T {
        var currentRetryCount = 0
        
        while true {
            do {
                return try await executeRequest(endpoint, method: method, body: body)
            } catch let error as URLError {
                throw parseURLError(error)
            } catch let error as APIError {
                logInfo("Request failed with error: \(error).")
                
                guard error.isRetryable, currentRetryCount < maxRetryCount else { throw error }
                
                // Increment retry count and calculate backoff delay
                currentRetryCount += 1
                logInfo("Start retrying request (\(currentRetryCount)) due to error: \(error).")
                let backoffDelay = calculateBackoffDelay(for: currentRetryCount)
                logInfo("Retrying request in \(backoffDelay) seconds...")
                
                // Wait for the backoff delay before retrying
                try await Task.sleep(nanoseconds: UInt64(backoffDelay * Double(NSEC_PER_SEC)))
            }
        }
    }
    
    func calculateBackoffDelay(for retryCount: Int) -> TimeInterval {
        return retryDelay * pow(2, Double(retryCount))
    }
    
    func executeRequest<T: Decodable>(_ endpoint: E, method: String, body: Data? = nil) async throws -> T {
        logInfo("Executing request for \(endpoint.path)...")
        
        let request = try createRequest(endpoint: endpoint, method: method, body: body)
        let (data, response) = try await session.data(for: request)
        
        _ = try validateResponse(response, endpoint: endpoint)
        return try decodeResponse(data)
    }
    
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
            logInfo("Requesting with token: \(token)")
        }
        
        if let body = body {
            request.httpBody = body
        }
        return request
    }
    
}

// MARK: - Response Validation

private extension HTTPService {
    
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
            guard httpResponse.statusCode != 401 else { throw APIError.unauthorized }
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
     Parses the given `URLError` into the corresponding `APIError`.
     
     - Parameters:
     - error: The `URLError` to parse.
     - endpoint: The optional `EndpointProtocol` associated with the error.
     
     - Returns: The corresponding `APIError` based on the `URLError` code.
     */
    func parseURLError(_ error: URLError, for endpoint: E? = nil) -> APIError {
        switch error.code {
        case .timedOut:
            logError("Request timed out.", endpoint: endpoint)
            return APIError.timeout
        case .cannotFindHost, .cannotConnectToHost, .networkConnectionLost:
            logError("Network error: \(error.localizedDescription)", endpoint: endpoint)
            return APIError.networkError(error)
        default:
            logError("Unexpected network error: \(error.localizedDescription)", endpoint: endpoint)
            return APIError.networkError(error)
        }
    }
}

// MARK: - Helper Methods

private extension HTTPService {
    func encodeToJSON<B: Encodable>(_ body: B) throws -> Data {
        do {
            return try JSONEncoder().encode(body)
        } catch {
            logError("Failed to encode JSON: \(error.localizedDescription)")
            throw APIError.encodingFailed
        }
    }
    
    func decodeResponse<T: Decodable>(_ data: Data) throws -> T {
        print("Trying to decode JSON...")
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
