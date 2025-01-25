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
                    Text(vm.task.title)
                        .font(theme.font.h3)
                        .fontWeight(.light)
                    StatusBadge(
                        status: vm.task.status,
                        size: .big
                    )
                    .padding(.top, -16)

                    if let description = vm.task.description {
                        Text(description)
                            .font(theme.font.h6)
                            .fontWeight(.thin)
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
                .frame(
                    maxWidth: .infinity,
                    minHeight: geometry.size.height,
                    alignment: .topLeading)
            }
            .foregroundStyle(theme.color.onSurface)
            .background(theme.color.surface)
        }
    }
}

#Preview {
    let userId = UUID()
    let components = ComponentManager(.development)
    let nav = NavigationManager()

    let task = TaskModel(
        id: UUID(),
        title: "Walk Brunello in the morning",
        description:
            "Please walk him as soon as possible because I have important meetings.",
        createdAt: Date()
            .addingTimeInterval(Double.random(in: -7...0) * 24 * 60 * 60),
        createdBy: userId,
        status: TaskStatus.allCases.randomElement()!,
        startAt:
            Bool
            .random()
            ? Date.now
                .addingTimeInterval(Double.random(in: -3...3) * 60 * 60) : nil,
        endAt:
            Bool
            .random()
            ? Date.now
                .addingTimeInterval(Double.random(in: 1...5) * 60 * 60) : nil,
        updatedAt:
            Bool
            .random()
            ? Date.now
                .addingTimeInterval(
                    Double.random(in: -1...1) * 24 * 60 * 60
                ) : nil,
        assignees: (1...Int.random(in: 1...3)).map { _ in
            let assigneeId = UUID()
            return TaskAssignee(
                id: assigneeId,
                firstName: ["Pedro", "Sofie", "Alex", "Maria", "John"]
                    .randomElement()!,
                lastName: ["Belfort", "Smith", "Doe", "Johnson", "Martinez"]
                    .randomElement()!
            )
        }
    )

    TaskDetailsScreen(components, task: task)
        .environment(components)
        .environment(nav)
}
