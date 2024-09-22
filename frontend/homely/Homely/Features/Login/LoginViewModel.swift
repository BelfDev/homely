//
//  LoginViewModel.swift
//  Homely
//
//  Created by Pedro Belfort on 22.09.24.
//

import Foundation

@Observable
final class LoginViewModel {
    private let homelyClient: HomelyAPIClient
    
    var email: String = ""
    var password: String = ""
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    init(with components: ComponentManager) {
        self.homelyClient = components.homelyClient
    }
    
    @MainActor
    func login() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let loginRequestBody = LoginRequestBody(email: email, password: password)
                let token = try await homelyClient.login(body: loginRequestBody)
                print(token)
                
                isLoading = false
                // Handle successful login, e.g., navigate to the home screen.
            } catch {
                isLoading = false
                errorMessage = "Login failed: \(error.localizedDescription)"
            }
        }
    }
}
