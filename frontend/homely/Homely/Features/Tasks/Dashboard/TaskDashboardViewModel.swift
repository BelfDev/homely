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
                let tasks = try await homelyClient.myTasks()
                self.tasks = tasks.sorted(by: { $0.createdAt > $1.createdAt })
            } catch let error as APIError {
                errorMessage = error.errorMessage
            } catch {
                errorMessage = SharedStrings.errorGeneric
            }
        }
    }
    
    @MainActor
    func deleteTask(_ task: TaskModel) {
        Task {
            do {
                try await homelyClient.deleteTask(task)
                self.tasks.removeAll { $0.id == task.id }
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
