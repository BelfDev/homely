//
//  LoginViewModel.swift
//  Homely
//
//  Created by Pedro Belfort on 22.09.24.
//

import Observation

@Observable
final class LoginViewModel {
    private let homelyClient: HomelyAPIClient
    
    private(set) var isAuthenticated: Bool = false
    private(set) var isLoading: Bool = false
    private(set) var errorMessage = "" {
        didSet {
            if (!errorMessage.isEmpty) {
                hasGeneralError = true
            }
        }
    }
    var hasGeneralError: Bool = false {
        didSet {
            if (!errorMessage.isEmpty && !hasGeneralError) {
                errorMessage = ""
            }
        }
    }
    
    var email: String = ""
    var password: String = ""
    
    init(with components: ComponentManager) {
        self.homelyClient = components.homelyClient
    }
    
    @MainActor
    func login() {
        isLoading = true
        
        Task {
            defer { isLoading = false }
            
            do {
                let loginRequestBody = LoginRequestBody(email: email, password: password)
                _ = try await homelyClient.login(body: loginRequestBody)
            } catch let error as APIError {
                errorMessage = error.errorMessage
            } catch {
                errorMessage = SharedStrings.errorGeneric
            }
        }
    }
}
