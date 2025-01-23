//
//  TaskRouter.swift
//  Homely
//
//  Created by Pedro Belfort on 29.12.24.
//

import SwiftUI

enum TaskRoute: Route, Equatable {
    case details(of: TaskModel)
    case newTask
}

struct TaskRouter: View {
    @ComponentsProvider private var components

    var body: some View {
        TaskDashboardScreen(components)
            .navigationDestination(for: TaskRoute.self) { destination in
                switch destination {
                case .details(let taskModel):
                    TaskDetailsScreen(components, task: taskModel)
                case .newTask:
                    NewTaskScreen(components)
                }
            }
    }
}
