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
    
    init(_ components: ComponentManager) {
        vm = TaskDashboardViewModel(with: components)
    }
    
    var body: some View {
        Text("Hello, World!")
        
        // Test
        Button("Go to Details") {
            navigator.push(TaskRoute.details)
        }
        .padding()
    }
    
}

#Preview {
    let components = ComponentManager(.development)
    TaskDashboardScreen(components)
        .environment(NavigationManager())
        .environment(components)
}
