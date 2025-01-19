//
//  NewTaskViewModel.swift
//  Homely
//
//  Created by Pedro Belfort on 18.01.25.
//

import Foundation

@Observable
final class NewTaskViewModel {
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
    
    var title: String = ""
    var description: String = ""
    var startAt: Date? = nil
    var endAt: Date? = nil

//    var validations: SignUpFormValidations?
    
    init(with components: ComponentManager) {
        self.homelyClient = components.homelyClient
    }
    
    // TODO(BelfDev): Review this later
//    @MainActor
//    func signUp() {
//        let body = SignUpRequestBody(
//            firstName: firstName,
//            lastName: lastName,
//            email: email,
//            password: password
//        )
//        validations = body.validate()
//        guard validations?.hasFieldErrors == false else { return }
//        
//        isLoading = true
//        
//        Task {
//            defer { isLoading = false }
//            do {
//                _ = try await homelyClient.signUp(body: body)
//            } catch let error as APIError {
//                errorMessage = error.errorMessage
//            } catch {
//                errorMessage = SharedStrings.errorGeneric
//            }
//        }
//    }
}
