//
//  TaskDetailsStrings.swift
//  Homely
//
//  Created by Pedro Belfort on 25.01.25.
//

import Foundation

struct TaskDetailsStrings {
    
    private static let table = "TaskDetailsScreen"
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    static let screenTitle = String(
        localized: "key:task_details_screen_title",
        table: table
    )
    
    static func created(at date: Date) -> String {
        return String(localized: "key:created_at", table: table)
            .replacingOccurrences(
                of: "%@",
                with: dateFormatter.string(from: date)
            )
    }
    static func updated(at date: Date) -> String {
        return String(localized: "key:last_updated_at", table: table)
            .replacingOccurrences(
                of: "%@",
                with: dateFormatter.string(from: date)
            )
    }
    
}
