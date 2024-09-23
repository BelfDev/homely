//
//  HomelyAPIClient.swift
//  Homely
//
//  Created by Pedro Belfort on 21.09.24.
//

import Foundation

protocol HomelyAPIClientProtocol {
    /**
     Logs in a user by sending their credentials to the server.
     
     - Parameter body: The login request body containing email and password.
     - Returns: A `User` object if the request is successful.
     - Throws: An error if the login fails.
     */
    func login(body: LoginRequestBody) async throws -> LoginResponse
}

final class HomelyAPIClient : HomelyAPIClientProtocol {
    private let environment: EnvConfig
    private let http: HTTPService<Endpoint>
    
    init(for environment: EnvConfig) {
        self.environment = environment
        self.http = HTTPService<Endpoint>(environment: environment, tokenProvider: HomelyAPITokenProvider())
    }
    
    // MARK: - API Endpoints
    
    enum Endpoint: EndpointProtocol {
        case login
        
        /**
         Returns the path for the given API endpoint.
         
         - Returns: A string representing the path for the endpoint.
         */
        var path: String {
            switch self {
            case .login:
                return "/api/v1/users/login"
            }
        }
        
        /**
         Constructs the full URL for the endpoint in the provided environment.
         
         - Parameter environment: The environment containing the base API URL.
         - Returns: The full URL for the endpoint.
         */
        func url(for environment: EnvConfig) -> String {
            return "\(environment.baseHomelyAPIUrl)\(path)"
        }
    }
    
    // MARK: - API Operations
    
    func login(body: LoginRequestBody) async throws -> LoginResponse {
        print("Performing login")
        return try await http.post(.login, body: body)
    }
}
