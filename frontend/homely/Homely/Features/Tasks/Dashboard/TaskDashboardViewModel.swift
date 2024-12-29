//
//  TaskDashboardViewModel.swift
//  Homely
//
//  Created by Pedro Belfort on 29.12.24.
//

import Foundation

final class TaskDashboardViewModel {
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
        
    init(with components: ComponentManager) {
        self.homelyClient = components.homelyClient
    }
        
    // TODO(BelfDev): Review this later
    @MainActor
    func fetchMyTasks() {
        isLoading = true
        Task {
            defer { isLoading = false }
            do {
                let tasks = try await homelyClient.myTasks()
                print("My tasks:\n")
                print(tasks)
               
            } catch let error as APIError {
                errorMessage = error.errorMessage
            } catch {
                errorMessage = SharedStrings.errorGeneric
            }
        }
    }
}

