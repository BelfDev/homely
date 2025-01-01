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
        
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading) {
                // Search Bar
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // Task List
                TaskListView(tasks: vm.tasks)
                    .padding([.top], 24)
            }
            
            // Floating Action Button
            HStack {
                Spacer()
                Button(action: {
                    // Action for adding a new task
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.blue))
                        .shadow(radius: 10)
                }
                .padding()
            }
        }
        .overlay {
            if vm.isLoading {
                LoadingOverlay()
            }
        }
        .background(theme.color.surface)
        .navigationTitle("Tasks")
        .toolbarTitleDisplayMode(.inlineLarge)
    }
}

#Preview {
    let components = ComponentManager(.development)
    TaskDashboardScreen(components)
        .environment(NavigationManager())
        .environment(components)
}
