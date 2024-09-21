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
     
     - Parameter input: The login request body containing email and password.
     - Returns: A `User` object if the request is successful.
     - Throws: An error if the login fails.
     */
    func login(input: LoginRequestBody) async throws -> User
}

final class HomelyAPIClient : HomelyAPIClientProtocol {
    private let environment: Environment
    private let http: HTTPService<Endpoint>
    
    init(for environment: Environment) {
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
        func url(for environment: Environment) -> String {
            return "\(environment.baseHomelyAPIUrl)\(path)"
        }
    }
    
    // MARK: - API Operations
    
    func login(input: LoginRequestBody) async throws -> User {
        let body = input.toDictionary()
        return try await http.post(.login, body: body)
    }
}
