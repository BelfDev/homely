//
//  TaskAdapter.swift
//  Homely
//
//  Created by Pedro Belfort on 29.12.24.
//

import Foundation

func tasksResponseToTaskList(_ tasksResponse: TasksResponse) -> [TaskModel] {
    return tasksResponse.tasks.map { taskIn in
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
