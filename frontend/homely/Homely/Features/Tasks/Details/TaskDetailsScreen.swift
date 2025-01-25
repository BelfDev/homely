//
//  TaskDetailsScreen.swift
//  Homely
//
//  Created by Pedro Belfort on 29.12.24.
//

import SwiftUI

struct TaskDetailsScreen: View {
    @ThemeProvider private var theme
    @NavigationManagerProvider private var navigator
    
    @State private var vm: TaskDetailsViewModel
    
    init(_ components: ComponentManager, task: TaskModel) {
        vm = TaskDetailsViewModel(components, task: task)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(vm.task.title)
                            .font(theme.font.h3)
                            .fontWeight(.light)
                        Spacer()
                        StatusBadge(status: vm.task.status)
                    }
                    
                    if let description = vm.task.description {
                        Text(description)
                            .font(theme.font.h6)
                            .fontWeight(.regular)
                    }
                    
                    
                    
                    Spacer()
                    
                    Group {
                        Text(TaskDetailsStrings.updated(at: vm.task.createdAt))
                            
                        if let updatedAt = vm.task.updatedAt {
                            Text(TaskDetailsStrings.updated(at: updatedAt))
                        }
                    }
                    .font(theme.font.body2)
                   
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity,
                       minHeight: geometry.size.height,
                       alignment: .topLeading)
            }
            .background(theme.color.surface)
        }
    }
}

#Preview {
    let components = ComponentManager(.development)
    let nav = NavigationManager()
    
    TaskDetailsScreen(components, task: TaskModel.makeStub())
        .environment(components)
        .environment(nav)
}
