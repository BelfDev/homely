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
    case unauthorized
    case timeout
}
