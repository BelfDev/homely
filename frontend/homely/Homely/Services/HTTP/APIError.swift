//
//  APIError.swift
//  Homely
//
//  Created by Pedro Belfort on 21.09.24.
//

import Foundation

enum APIError: Error, Equatable {
    case invalidURL
    case noData
    case invalidResponse
    case clientError(Int)   // For 4xx status codes
    case serverError(Int)   // For 5xx status codes
    case unexpectedStatusCode(Int) // Any unexpected status codes
    case encodingFailed
    case duplicateRequest
    case unauthorized
    case timeout
    case networkError(URLError) // For generic network errors like connection loss
    
    // Helper function to identify retryable errors
    var isRetryable: Bool {
        switch self {
        case .serverError(let statusCode):
            // Retry on server errors like Bad Gateway, Service Unavailable, and Gateway Timeout
            return [502, 503, 504].contains(statusCode)
        case .timeout, .networkError:
            // Retry on timeout or network issues
            return true
        default:
            return false
        }
    }
}

// MARK: - Error Feedback

extension APIError {
    
    var errorMessage: String {
        switch self {
        case .unauthorized:
            return SharedStrings.errorInvalidCredentials
        case .timeout:
            return SharedStrings.errorRequestTimeout
        case .networkError(let error):
            return error.localizedDescription
        default:
            return SharedStrings.errorGeneric
        }
    }
}
