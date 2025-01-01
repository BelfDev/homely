//
//  TasksResponse.swift
//  Homely
//
//  Created by Pedro Belfort on 29.12.24.
//

import Foundation

enum TaskStatusIn: String, Decodable {
    case opened = "OPENED"
    case inProgress = "IN_PROGRESS"
    case contested = "CONTESTED"
    case done = "DONE"
}

struct TaskAssigneeIn: Identifiable, Decodable {
    let userId: UUID
    let firstName: String
    let lastName: String
    
    var id: UUID { userId }
}

struct TaskIn: Identifiable, Decodable {
    let id: UUID
    let title: String
    let description: String
    let createdAt: Date
    let createdBy: UUID
    let status: TaskStatusIn
    let startAt: Date?
    let endAt: Date?
    let updatedAt: Date?
    let assignees: [TaskAssigneeIn]
}

struct TasksResponse: Decodable {
    let tasks: [TaskIn]
}

// MARK: - Adapters

extension TasksResponse {
    func toTaskList() -> [TaskModel] {
        return self.tasks.map { taskIn in
            TaskModel(
                id: taskIn.id,
                title: taskIn.title,
                description: taskIn.description,
                createdAt: taskIn.createdAt,
                createdBy: taskIn.createdBy,
                status: TaskStatus(rawValue: taskIn.status.rawValue)!,
                startAt: taskIn.startAt,
                endAt: taskIn.endAt,
                updatedAt: taskIn.updatedAt,
                assignees: taskIn.assignees.map { assigneeIn in
                    TaskAssignee(
                        id: assigneeIn.userId,
                        firstName: assigneeIn.firstName,
                        lastName: assigneeIn.lastName
                    )
                }
            )
        }
    }
}
