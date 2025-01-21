//
//  TaskListView.swift
//  Homely
//
//  Created by Pedro Belfort on 01.01.25.
//

import SwiftUI

struct TaskListView: View {
    let tasks: [TaskModel]
    let onDelete: (TaskModel) -> Void
       
    var body: some View {
        
        List {
            ForEach(tasks, id: \.id) { task in
                TaskCard(task: task)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
            .onDelete { indexSet in
                indexSet.forEach { self.onDelete(tasks[$0]) }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    let components = ComponentManager(.development)
    TaskListView(
        tasks: TaskModel.makeStubStaticList(),
        onDelete: { _ in }
    )
    .environment(components)
}
