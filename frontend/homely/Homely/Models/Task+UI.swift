//
//  Task+UI.swift
//  Homely
//
//  Created by Pedro Belfort on 11.01.25.
//

import Foundation

extension TaskAssignee {
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

extension TaskModel {
    private func relativeDateString(for date: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let targetDay = calendar.startOfDay(for: date)
        let daysDifference = calendar.dateComponents(
            [.day],
            from: today,
            to: targetDay
        ).day ?? 0
        let timeFormatted = date.formatted(date: .omitted, time: .shortened)
        
        switch daysDifference {
        case 0:
            return String(format: TaskStrings.todayWithTime, timeFormatted)
        case 1:
            return String(format: TaskStrings.tomorrowWithTime, timeFormatted)
        case -1:
            return TaskStrings.yesterday
        case 2...6:
            return TaskStrings.inDays(daysDifference)
        case -6...(-2):
            return TaskStrings.daysAgo(abs(daysDifference))
        case 7...27:
            return TaskStrings.inWeeks(daysDifference / 7)
        case -27...(-7):
            return TaskStrings.weeksAgo(abs(daysDifference / 7))
        default:
            return date.formatted(date: .abbreviated, time: .omitted)
        }
    }
    
    var formattedRelativeTimeRange: String? {
        switch (startAt, endAt) {
        case let (startAt?, endAt?):
            let startString = relativeDateString(for: startAt)
            let endString = relativeDateString(for: endAt)
            return "\(startString) - \(endString)"
        case let (startAt?, nil):
            let startString = relativeDateString(for: startAt)
            return "\(startString) - ∞"
        case let (nil, endAt?):
            let endString = relativeDateString(for: endAt)
            return "∞ - \(endString)"
        default:
            return nil
        }
    }
}
