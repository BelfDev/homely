//
//  TaskCard.swift
//  Homely
//
//  Created by Pedro Belfort on 01.01.25.
//

import SwiftUI

private struct StatusBadge: View {
    @ThemeProvider private var theme
    
    let status: TaskStatus

    var body: some View {
        Text(status.rawValue)
            .font(theme.font.caption)
            .fontWeight(.semibold)
            .foregroundColor(theme.color.onSecondary)
            .padding(8)
            .background(status.color(theme.color))
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
        .padding()
        .background(status.color(theme.color).opacity(0.2))
        .cornerRadius(16)
        //        .shadow(color: theme.color.shadow, radius: 16)
    }
}

private extension TaskModel {
    // TODO(BelfDev): localize and create more advanced formats
    var formattedTimeRange: String? {
        switch (startAt, endAt) {
        case let (startAt?, endAt?):
            return "from \(startAt.formatted(date: .abbreviated, time: .shortened)) \nuntil \(endAt.formatted(date: .abbreviated, time: .shortened))"
        case let (startAt?, nil):
            return "from \(startAt.formatted(date: .abbreviated, time: .shortened))"
        case let (nil, endAt?):
            return "until \(endAt.formatted(date: .abbreviated, time: .shortened))"
        default:
            return nil
        }
    }
}

private extension TaskStatus {
    
    // TODO(BelfDev): Use theme instead.
    func color(_ colorTheme: ColorThemeProtocol) -> Color {
        switch self {
        case .done:
            return .green
        case .contested:
            return .red
        case .inProgress:
            return .orange
        case .opened:
            return .gray
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
