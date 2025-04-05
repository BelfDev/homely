//
//  TaskListView.swift
//  Homely
//
//  Created by Pedro Belfort on 01.01.25.
//

import SwiftUI

struct TaskListView: View {
    @ThemeProvider private var theme
    
    let tasks: [TaskModel]
    let onDelete: (TaskModel) -> Void
    let onPress: (TaskModel) -> Void
    let onLongPress: (TaskModel) -> Void
       
    var body: some View {
        
        List(tasks, id: \.id) { task in
            TaskCard(task: task)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(
                        SharedStrings.swipeToDeleteButton,
                        role: .destructive,
                        action: { onDelete(task) }
                    )
                    .tint(theme.color.error)
                }
                .onTapGesture(perform: { onPress(task) })
                .onLongPressGesture(minimumDuration: 0.5) {
                    onLongPress(task)
                }
        }
        .listStyle(.plain)
    }
}

#Preview {
    let components = ComponentManager(.development)
    TaskListView(
        tasks: TaskModel.makeStubStaticList(),
        onDelete: { _ in },
        onPress: { _ in },
        onLongPress: { _ in }
    )
    .environment(components)
}
