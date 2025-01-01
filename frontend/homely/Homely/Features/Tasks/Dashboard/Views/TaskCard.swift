//
//  TaskCard.swift
//  Homely
//
//  Created by Pedro Belfort on 01.01.25.
//

import SwiftUI

private struct StatusBadge: View {
    let title: String
    let color: Color
    
    init(status: TaskStatus) {
        self.title = status.rawValue
        self.color = status.color
    }

    var body: some View {
        Text(title)
            .font(.caption)
            .bold()
            .foregroundColor(.white)
            .padding(8)
            .background(color)
            .cornerRadius(16)
    }
}

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
        self.timeRange = task.formattedTimeRange
        self.status = task.status
        self.assigneeImage = "person.circle"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                StatusBadge(status: self.status)
            }

            if let description = description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            HStack {
                if let timeRange {
                    Image(systemName: "clock")
                        .foregroundColor(.secondary)
                    Text(timeRange)
                        .font(.caption)
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
        .padding()
        .background(status.color.opacity(0.2))
        .cornerRadius(16)
//        .shadow(color: theme.color.shadow, radius: 16)
    }
}

private extension TaskModel {
    var formattedTimeRange: String? {
        switch (startAt, endAt) {
        case let (startAt?, endAt?):
            return "\(startAt.formatted(date: .omitted, time: .shortened)) - \(endAt.formatted(date: .omitted, time: .shortened))"
        case let (startAt?, nil):
            return "\(startAt.formatted(date: .omitted, time: .shortened)) -"
        case let (nil, endAt?):
            return "- \(endAt.formatted(date: .omitted, time: .shortened))"
        default:
            return nil
        }
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
