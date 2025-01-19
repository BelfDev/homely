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
    
    private(set) var taskCreated: Bool = false
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

    var validations: NewTaskFormValidations?
    
    init(with components: ComponentManager) {
        self.homelyClient = components.homelyClient
    }
    
    @MainActor
    func createNewTask() {
        let description = description.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        let body = NewTaskRequestBody(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.isEmpty ? nil : description,
            start: startAt,
            end: endAt
        )
        
        validations = body.validate()
        guard validations?.hasFieldErrors == false else { return }
        
        isLoading = true
        
        Task {
            defer { isLoading = false }
            do {
                _ = try await homelyClient.createNewTask(body: body)
                taskCreated = true
            } catch let error as APIError {
                errorMessage = error.errorMessage
            } catch {
                errorMessage = SharedStrings.errorGeneric
            }
        }
    }
}
