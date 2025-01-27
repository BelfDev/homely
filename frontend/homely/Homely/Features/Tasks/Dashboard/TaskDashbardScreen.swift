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

    @State private var isQuickUpdateMenuVisible = false
    @State private var selectedTask: TaskModel?

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
                    // TODO(BelfDev): Review this logic later.
                    selectedTask = task
                    isQuickUpdateMenuVisible = true
                }
            )
            .background(theme.color.surface)
            .navigationTitle(TaskStrings.dashboardScreenTitle)
            .toolbarTitleDisplayMode(.large)
            .overlay {
                if vm.isLoading {
                    LoadingOverlay()
                }

                // TODO(BelfDev): Review this logic later.
                if isQuickUpdateMenuVisible, let task = selectedTask {
                    QuickStatusUpdateView(
                        task: task,
                        onStatusChange: { newStatus in
                            vm.updateTaskStatus(task, to: newStatus)
                            isQuickUpdateMenuVisible = false
                        },
                        onClose: {
                            isQuickUpdateMenuVisible = false
                        }
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut, value: isQuickUpdateMenuVisible)
                }
            }

            FloatingActionButton(actionType: .add) {
                navigator.push(TaskRoute.newTask)
            }
            .padding(.trailing, 19)

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
