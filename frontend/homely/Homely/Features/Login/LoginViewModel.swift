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
    private let localStore: LocalStoreManager
    
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
    var validations: LoginFormValidations?
    
    init(with components: ComponentManager) {
        self.homelyClient = components.homelyClient
        self.localStore = LocalStoreManager()
    }
    
    @MainActor
    func login() {
        let body = LoginRequestBody(
            email: email,
            password: password
        )
        validations = body.validate()
        guard validations?.hasFieldErrors == false else { return }
        
        isLoading = true
        
        Task {
            defer { isLoading = false }
            do {
                _ = try await homelyClient.login(body: body)
                if await localStore.saveCredentials(
                    email: email,
                    password: password
                ) {
                    print("Credentials saved to Keychain")
                }
            } catch let error as APIError {
                errorMessage = error.errorMessage
            } catch {
                errorMessage = SharedStrings.errorGeneric
            }
        }
    }
    
    @MainActor
    func autofillCredentialsIfPossible() {
        Task {
            guard let savedEmail = await localStore.getLastUsedEmail() else { return }
            guard let savedPassword = await localStore.getCredentials(for: savedEmail) else { return }
            
            email = savedEmail
            password = savedPassword
        }
    }
}
