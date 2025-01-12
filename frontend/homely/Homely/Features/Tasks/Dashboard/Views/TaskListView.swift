//
//  TaskListView.swift
//  Homely
//
//  Created by Pedro Belfort on 01.01.25.
//

import SwiftUI

struct TaskListView: View {
    let tasks: [TaskModel]
       
    var body: some View {
        List(tasks, id: \.id) { task in
            TaskCard(task: task)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
    }
}

#Preview {
    let components = ComponentManager(.development)
    TaskListView(
        tasks: TaskModel.makeStubStaticList()
    )
    .environment(components)
}
