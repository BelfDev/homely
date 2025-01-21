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
                onDelete: vm.deleteTask
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
        }
        .onAppear() {
            vm.fetchMyTasks()
        }
    }
}

#Preview {
    let components = ComponentManager(.development)
    let nav = NavigationManager()
    
    NavigationStack() {
        TaskDashboardScreen(components)
            .environment(nav)
            .environment(components)
    }
}
