//
//  TaskCard.swift
//  Homely
//
//  Created by Pedro Belfort on 01.01.25.
//

import SwiftUI

struct TaskCard: View {
    @ThemeProvider private var theme
    let task: TaskModel
    
    var body: some View {
        VStack {
            Text(task.title)
            Text(task.status.rawValue)
            if let startAt = task.startAt {
                Image(systemName: "clock")
                Text(startAt.formatted(date: .omitted, time: .shortened))
                if let endAt = task.endAt {
                    Text(endAt.formatted(date: .omitted, time: .shortened))
                }
            }
            
            ForEach(task.assignees) { assignee in
                Text(assignee.fullName)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.color.secondaryContainer)
        .cornerRadius(24)
        .shadow(color: theme.color.shadow, radius: 16)
    }
}

#Preview {
    let components = ComponentManager(.development)
    TaskCard(
        task: TaskModel.makeStub()
    )
    .environment(components)
    .padding()
}
