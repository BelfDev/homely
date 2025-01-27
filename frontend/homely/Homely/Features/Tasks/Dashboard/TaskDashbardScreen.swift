//
//  TaskDashbardScreen.swift
//  Homely
//
//  Created by Pedro Belfort on 29.12.24.
//

import SwiftUI

struct TaskDashboardScreen: View {

    @ThemeProvider private var theme
    @NavigationManagerProvider private var navigator

    @State private var vm: TaskDashboardViewModel
    @State private var searchText = ""
    @State private var selectedDate = Date()

    init(_ components: ComponentManager) {
        vm = TaskDashboardViewModel(with: components)
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TaskListView(
                tasks: vm.tasks,
                onDelete: vm.deleteTask,
                onPress: { task in
                    navigator.push(TaskRoute.details(of: task))
                },
                onLongPress: { task in

                }
            )
            .background(theme.color.surface)
            .navigationTitle(TaskStrings.dashboardScreenTitle)
            .toolbarTitleDisplayMode(.large)
            .overlay {
                if vm.isLoading {
                    LoadingOverlay()
                }
            }

            FloatingActionButton(actionType: .add) {
                navigator.push(TaskRoute.newTask)
            }
            .padding(.trailing, 19)

            if let task = vm.selectedTask {
                QuickStatusUpdateView(
                    task: task,
                    onStatusChange: { newStatus in
                        vm.updateTaskStatus(task, to: newStatus)
                        vm.selectedTask = nil
                    },
                    onClose: {
                        vm.selectedTask = nil
                    }
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.spring(), value: vm.selectedTask != nil)
            }
        }
        .onAppear {
            vm.fetchMyTasks()
        }
    }
}

#Preview {
    let components = ComponentManager(.development)
    let nav = NavigationManager()

    NavigationStack {
        TaskDashboardScreen(components)
            .environment(nav)
            .environment(components)
    }
}
