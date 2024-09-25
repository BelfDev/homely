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
    
    var email: String = ""
    var password: String = ""
    private(set) var isLoading: Bool = false
    var hasGeneralError: Bool = false
    private(set) var errorMessage: String? = nil
    
    init(with components: ComponentManager) {
        self.homelyClient = components.homelyClient
    }
    
//    @MainActor
//    func login() {
//        isLoading = true
//        errorMessage = nil
//        
//        Task {
//            do {
//                let loginRequestBody = LoginRequestBody(email: email, password: password)
//                let response = try await homelyClient.login(body: loginRequestBody)
//                print("We're good!!!")
//                print("Token:\n \(response.accessToken)")
//                
//                isLoading = false
//            } catch {
//                isLoading = false
//                errorMessage = "Login failed: \(error.localizedDescription)"
//            }
//        }
//    }
    
    @MainActor
    func login() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                print("Trigerring mock login")
                try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
                
                let mockResponse = LoginResponse(accessToken: "mock_access_token")
                print("We're good!!!")
                print("Token:\n \(mockResponse.accessToken)")
                
                isLoading = false
                hasGeneralError = true
                errorMessage = "TEST ERROR LALALA"
            } catch {
                isLoading = false
                errorMessage = "Login failed: \(error.localizedDescription)"
            }
        }
    }
}
