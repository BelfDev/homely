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
        vm.fetchMyTasks()
    }
    
    var body: some View {
        
        // TaskListView(tasks: vm.tasks)
        
        ZStack(alignment: .bottomTrailing) {
            TaskListView(
                tasks: TaskModel
                    .makeStubStaticList() + TaskModel
                    .makeStubStaticList()
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
                // Do something
            }
            .padding(.trailing, 19)
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
