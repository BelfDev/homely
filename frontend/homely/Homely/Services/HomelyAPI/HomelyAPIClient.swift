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
        case login, signUp, myTasks
        
        /**
         Returns the path for the given API endpoint.
         
         - Returns: A string representing the path for the endpoint.
         */
        var path: String {
            switch self {
            case .login:
                return "/api/v1/users/login"
            case .signUp:
                return "/api/v1/users"
            case .myTasks:
                return "/api/v1/tasks"
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
    
    /**
     Creates a new user and logs them in by sending their details to the server.

     - Parameter body: A `SignUpRequestBody` containing the user's sign-up details such as email, password, first name, and last name.
     - Returns: A `SignUpResponse` object containing the newly created user's details and access token.
     - Throws: An error if the login request fails or if storing the token encounters an error.
     
     - Important:
        - The method automatically logs in the user after registration by storing the returned access token using the `TokenProviderProtocol`. This token is used for subsequent authenticated API requests.
     */
    func signUp(body: SignUpRequestBody) async throws -> SignUpResponse {
        let response: SignUpResponse = try await http.post(.signUp, body: body)
        
        try tokenProvider.setToken(response.accessToken)
        return response
    }
    
    func myTasks() async throws -> [TaskModel] {
        let response: TasksResponse = try await http.get(.myTasks)
        let parsedTasks = response.toTaskList()
        return parsedTasks
    }
}
