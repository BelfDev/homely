//
//  LoginViewModel.swift
//  Homely
//
//  Created by Pedro Belfort on 22.09.24.
//

import Observation
import LocalAuthentication

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
    var saveCredentials: Bool = false
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
                if saveCredentials {
                    _ = await localStore.saveCredentials(email: email, password: password)
                } else {
                    _ = await localStore.deleteCredentials(for: email)
                }
            } catch let error as APIError {
                errorMessage = error.errorMessage
            } catch {
                errorMessage = SharedStrings.errorGeneric
            }
        }
    }
    
    @MainActor
    func autoLastEnteredEmail() {
        Task {
            guard let savedEmail = await localStore.getLastUsedEmail() else { return }
            email = savedEmail
        }
    }
    
    // TODO(BelfDev) Add translations
    @MainActor
    func authenticateWithFaceID() {
        let context = LAContext()
        let reason = "Authenticate with Face ID to log in."
        
        Task {
            do {
                guard try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) else { return }
                guard let savedPassword = await localStore.getCredentials(for: email) else {
                    errorMessage = "No password found for this email on Keychain"
                    return
                }
                password = savedPassword
            } catch {
                errorMessage = "Face ID is not available on this device."
            }
        }
    }
}
