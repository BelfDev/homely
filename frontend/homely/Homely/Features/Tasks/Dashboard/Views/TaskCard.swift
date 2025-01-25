//
//  TaskCard.swift
//  Homely
//
//  Created by Pedro Belfort on 01.01.25.
//

import SwiftUI

struct TaskCard: View {
    @ThemeProvider private var theme
    
    let title: String
    let description: String?
    let timeRange: String?
    let status: TaskStatus
    let assigneeImage: String?
    
    init(task: TaskModel) {
        self.title = task.title
        self.description = task.description
        self.timeRange = task.formattedRelativeTimeRange
        self.status = task.status
        self.assigneeImage = "person.circle"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                Text(title)
                    .font(theme.font.h5)
                    .fontWeight(.semibold)
                Spacer()
                StatusBadge(status: status)
            }

            if let description = description {
                Text(description)
                    .font(theme.font.body1)
                    .foregroundColor(theme.color.onSurface)
            }

            HStack {
                if let timeRange {
                    Image(systemName: "clock")
                        .foregroundColor(theme.color.secondary)
                    Text(timeRange)
                        .font(theme.font.caption)
                        .foregroundColor(theme.color.secondary)
                }
                
                Spacer()

                if let assigneeImage = assigneeImage {
                    Image(systemName: assigneeImage)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .clipShape(Circle())
                }
            }
        }
        .padding(12)
        .background(status.color(theme.color).opacity(0.2))
        .cornerRadius(16)
    }
}

#Preview {
    let components = ComponentManager(.development)

    TaskCard(
        task: TaskModel.makeStubStaticList()[0]
    )
    .environment(components)
    .padding()
    
    TaskCard(
        task: TaskModel.makeStubStaticList()[1]
    )
    .environment(components)
    .padding()
    
    TaskCard(
        task: TaskModel.makeStubStaticList()[2]
    )
    .environment(components)
    .padding()
    
    TaskCard(
        task: TaskModel.makeStubStaticList()[3]
    )
    .environment(components)
    .padding()
}
