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
        
        TaskListView(tasks: vm.tasks)
            .padding([.top], 24)
            .overlay {
                if vm.isLoading {
                    LoadingOverlay()
                }
            }
            .background(theme.color.surface)
            .navigationTitle(TaskStrings.dashboardScreenTitle)
            .toolbarTitleDisplayMode(.large)
       
        //        ZStack(alignment: .bottomTrailing) {
        //            VStack(alignment: .leading) {
        //                //                TaskListView(tasks: TaskModel.makeStubStaticList())
        //                //                    .padding([.top], 24)
        //                TaskListView(tasks: vm.tasks)
        //                    .padding([.top], 24)
        //            }
        //            
        //            // Floating Action Button
        //            HStack {
        //                Spacer()
        //                Button(action: {
        //                    // Action for adding a new task
        //                }) {
        //                    Image(systemName: "plus")
        //                        .font(.title)
        //                        .foregroundColor(theme.color.onPrimary)
        //                        .padding()
        //                        .background(Circle().fill(theme.color.primary))
        //                        .shadow(color: theme.color.shadow, radius: 10)
        //                }
        //                .padding()
        //            }.hidden() // Change later
        //        }
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
