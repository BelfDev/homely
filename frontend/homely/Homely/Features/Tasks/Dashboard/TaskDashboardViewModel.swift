//
//  TaskDashboardViewModel.swift
//  Homely
//
//  Created by Pedro Belfort on 29.12.24.
//

import Foundation

@Observable
final class TaskDashboardViewModel {
    private let homelyClient: HomelyAPIClient
    private(set) var isLoading: Bool = false
    private(set) var errorMessage = ""
    private(set) var tasks: [TaskModel] = []
        
    init(with components: ComponentManager) {
        self.homelyClient = components.homelyClient
    }
        
    @MainActor
    func fetchMyTasks() {
        isLoading = true
        clearErrors()
        
        Task {
            defer { isLoading = false }
            do {
                self.tasks = try await homelyClient.myTasks()
            } catch let error as APIError {
                errorMessage = error.errorMessage
            } catch {
                errorMessage = SharedStrings.errorGeneric
            }
        }
    }
    
    func clearErrors() {
        errorMessage = ""
    }
    
}
