//
//  TaskRouter.swift
//  Homely
//
//  Created by Pedro Belfort on 29.12.24.
//

import SwiftUI

enum TaskRoute: Route {
    case details
    case newTask
}

struct TaskRouter: View {
    @ComponentsProvider private var components

    var body: some View {
        TaskDashboardScreen(components)
            .navigationDestination(for: TaskRoute.self) { destination in
                switch destination {
                case .details:
                    TaskDetailsScreen()
                case .newTask:
                    NewTaskScreen(components)
                }
            }
    }
}
