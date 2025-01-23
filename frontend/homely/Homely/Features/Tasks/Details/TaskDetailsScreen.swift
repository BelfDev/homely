//
//  TaskDetailsScreen.swift
//  Homely
//
//  Created by Pedro Belfort on 29.12.24.
//

import SwiftUI

struct TaskDetailsScreen: View {
    @NavigationManagerProvider private var navigator
    
    @State private var vm: TaskDetailsViewModel
    
    init(_ components: ComponentManager, task: TaskModel) {
        vm = TaskDetailsViewModel(components, task: task)
    }
    
    var body: some View {
        Text("Hello, World!")
        
        Text(vm.task.title)
        
        
        // Test
        Button("Pop to root") {
            navigator.popToRoot()
        }
        .padding()
    }
}

#Preview {
    let components = ComponentManager(.development)
    let nav = NavigationManager()
    
    TaskDetailsScreen(components, task: TaskModel.makeStub())
        .environment(components)
        .environment(nav)
}
