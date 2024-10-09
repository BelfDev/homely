//
//  SignUpViewModel.swift
//  Homely
//
//  Created by Pedro Belfort on 08.10.24.
//

import Foundation

@Observable
final class SignUpViewModel {
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
    
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var password: String = ""
    
    var validations: SignUpFormValidations?
    
    init(with components: ComponentManager) {
        self.homelyClient = components.homelyClient
    }
    
    // TODO(BelfDev): Review this later
    @MainActor
    func signUp() {
        let signUpRequestBody = SignUpRequestBody(firstName: firstName,
                                                  lastName: lastName,
                                                  email: email,
                                                  password: password)
        validations = signUpRequestBody.validate()
        guard validations?.hasFieldErrors == false else { return }
        
        isLoading = true
        
        Task {
            defer { isLoading = false }
            do {
                _ = try await homelyClient.signUp(body: signUpRequestBody)
            } catch let error as APIError {
                errorMessage = error.errorMessage
            } catch {
                errorMessage = SharedStrings.errorGeneric
            }
        }
    }
}
