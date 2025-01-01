//
//  Task.swift
//  Homely
//
//  Created by Pedro Belfort on 29.12.24.
//

import Foundation

enum TaskStatus: String, Codable {
    case opened = "OPENED"
    case inProgress = "IN_PROGRESS"
    case contested = "CONTESTED"
    case done = "DONE"
}

struct TaskAssignee: Identifiable, Codable {
    let id: UUID
    let firstName: String
    let lastName: String
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

// Note: the "Model" suffix was used to prevent collision with Swift's built-in "Task".
struct TaskModel: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let createdAt: Date
    let createdBy: UUID
    let status: TaskStatus
    let startAt: Date?
    let endAt: Date?
    let updatedAt: Date?
    let assignees: [TaskAssignee]
}

extension TaskModel {
    
    static func makeStub() -> TaskModel {
        let userId = UUID()
        return TaskModel(
            id: userId,
            title: "Task title",
            description: "Task description",
            createdAt: Date(),
            createdBy: userId,
            status: .done,
            startAt:  Date.now,
            endAt: Date.now.addingTimeInterval(2 * 60 * 60),
            updatedAt: nil,
            assignees: [
                TaskAssignee(id: userId, firstName: "Pedro", lastName: "Belfort")
            ]
        )
    }
}
