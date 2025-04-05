//
//  Task.swift
//  Homely
//
//  Created by Pedro Belfort on 29.12.24.
//

import Foundation

struct TaskAssignee: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let firstName: String
    let lastName: String
}

// Note: the "Model" suffix was used to prevent collision with Swift's built-in "Task".
struct TaskModel: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let title: String
    let description: String?
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
            id: UUID(),
            title: [
                "Do the dishes",
                "Take out the trash",
                "Water the plants",
                "Finish report",
                "Plan trip"
            ]
                .randomElement()!,
            description: Bool
                .random() ? [
                    "Task description",
                    "Optional description",
                    "Complete this by the end of the day",
                    "Requires extra attention",
                ].randomElement()! : nil,
            createdAt: Date()
                .addingTimeInterval(Double.random(in: -7...0) * 24 * 60 * 60),
            createdBy: userId,
            status: TaskStatus.allCases.randomElement()!,
            startAt: Bool
                .random() ? Date.now
                .addingTimeInterval(Double.random(in: -3...3) * 60 * 60) : nil,
            endAt: Bool
                .random() ? Date.now
                .addingTimeInterval(Double.random(in: 1...5) * 60 * 60) : nil,
            updatedAt: Bool
                .random() ? Date.now
                .addingTimeInterval(
                    Double.random(in: -1...1) * 24 * 60 * 60
                ) : nil,
            assignees: (1...Int.random(in: 1...3)).map { _ in
                let assigneeId = UUID()
                return TaskAssignee(
                    id: assigneeId,
                    firstName: ["Pedro", "Sofie", "Alex", "Maria", "John"]
                        .randomElement()!,
                    lastName: ["Belfort", "Smith", "Doe", "Johnson", "Martinez"]
                        .randomElement()!
                )
            }
        )
    }
    
    static func makeStubRandomList(count: Int = 10) -> [TaskModel] {
        (1...count).map() { _ in makeStub() }
    }
    
    static func makeStubStaticList() -> [TaskModel] {
        let userId = UUID()
        return [
            TaskModel(
                id: UUID(),
                title: "Do the dishes",
                description: "Task description",
                createdAt: Date()
                    .addingTimeInterval(
                        Double.random(in: -7...0) * 24 * 60 * 60
                    ),
                createdBy: userId,
                status: TaskStatus.opened,
                startAt: nil,
                endAt: nil,
                updatedAt: nil,
                assignees: (1...Int.random(in: 1...3)).map { _ in
                    let assigneeId = UUID()
                    return TaskAssignee(
                        id: assigneeId,
                        firstName: ["Pedro", "Sofie", "Alex", "Maria", "John"]
                            .randomElement()!,
                        lastName: [
                            "Belfort",
                            "Smith",
                            "Doe",
                            "Johnson",
                            "Martinez"
                        ]
                            .randomElement()!
                    )
                }
            ),
            TaskModel(
                id: UUID(),
                title: "Take out the trash",
                description: nil,
                createdAt: Date()
                    .addingTimeInterval(
                        Double.random(in: -7...0) * 24 * 60 * 60
                    ),
                createdBy: userId,
                status: TaskStatus.inProgress,
                startAt: Date.now,
                endAt: nil,
                updatedAt: nil,
                assignees: []
            ),
            TaskModel(
                id: UUID(),
                title: "Water the plants",
                description: "Complete this by the end of the day",
                createdAt: Date()
                    .addingTimeInterval(
                        Double.random(in: -7...0) * 24 * 60 * 60
                    ),
                createdBy: userId,
                status: TaskStatus.done,
                startAt: Date.now
                    .addingTimeInterval(Double.random(in: -3...3) * 60 * 60),
                endAt: Date.now
                    .addingTimeInterval(Double.random(in: 1...5) * 60 * 60),
                updatedAt: nil,
                assignees: []
            ),
            TaskModel(
                id: UUID(),
                title: "Finish report",
                description:  "Requires extra attention; Requires extra attention; Requires extra attention; Requires extra attention; Requires extra attention; Requires extra attention",
                createdAt: Date()
                    .addingTimeInterval(
                        Double.random(in: -7...0) * 24 * 60 * 60
                    ),
                createdBy: userId,
                status: TaskStatus.contested,
                startAt: nil,
                endAt: Date.now
                    .addingTimeInterval(Double.random(in: 1...5) * 60 * 60),
                updatedAt: Date.now
                    .addingTimeInterval(
                        Double.random(in: -1...1) * 24 * 60 * 60
                    ),
                assignees: []
            )
        ]
    }
}
