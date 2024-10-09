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
    private let tokenProvider: TokenProviderProtocol
    
    init(for environment: EnvConfig, with tokenProvider: TokenProviderProtocol) {
        self.environment = environment
        self.tokenProvider = tokenProvider
        self.http = HTTPService<Endpoint>(
            environment: environment,
            tokenProvider: self.tokenProvider
        )
    }
    
    // MARK: - API Endpoints
    
    enum Endpoint: EndpointProtocol {
        case login, signUp
        
        /**
         Returns the path for the given API endpoint.
         
         - Returns: A string representing the path for the endpoint.
         */
        var path: String {
            switch self {
            case .login:
                return "/api/v1/users/login"
            case .signUp:
                return "/api/v1/users/signup"
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
    
    /**
     Logs in the user with the given credentials and stores the access token.
     
     - Parameter body: A `LoginRequestBody` containing the user's login credentials.
     - Returns: A `LoginResponse` object containing the access token.
     - Throws: An error if the login request fails or if storing the token encounters an error.
     */
    func login(body: LoginRequestBody) async throws -> LoginResponse {
        let response: LoginResponse = try await http.post(.login, body: body)
        
        try tokenProvider.setToken(response.accessToken)
        return response
    }
    
    // TODO(BelfDev): Review this later
    func signUp(body: SignUpRequestBody) async throws -> SignUpResponse {
        let response: SignUpResponse = try await http.post(.signUp, body: body)
        
        try tokenProvider.setToken(response.accessToken)
        return response
    }
}
