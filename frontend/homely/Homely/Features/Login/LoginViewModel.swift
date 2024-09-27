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
    
    //        @MainActor
    //        func login() {
    //            isLoading = true
    //
    //            Task {
    //                defer {isLoading = false}
    //
    //                do {
    //                    let loginRequestBody = LoginRequestBody(email: email, password: password)
    //                    let response = try await homelyClient.login(body: loginRequestBody)
    //                    print("We're good!!!")
    //                    print("Token:\n \(response.accessToken)")
    //                } catch let error as APIError {
    //                    errorMessage = error.errorMessage
    //                } catch {
    //                    errorMessage = SharedStrings.errorGeneric
    //                }
    //            }
    //        }
    
    @MainActor
    func login() {
        isLoading = true
        
        Task {
            defer {isLoading = false}
            
            do {
                print("Trigerring mock login")
                try await Task.sleep(nanoseconds: 4 * 1_000_000_000)
                
                let mockResponse = LoginResponse(accessToken: "mock_access_token")
                
                errorMessage = SharedStrings.errorInvalidCredentials
            } catch {
                errorMessage = SharedStrings.errorInvalidCredentials
            }
        }
    }
}
