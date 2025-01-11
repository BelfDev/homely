//
//  TaskStrings.swift
//  Homely
//
//  Created by Pedro Belfort on 11.01.25.
//

import SwiftUI

struct TaskStrings {
    private static let table = "Task"
    
    static let openStatus = String(localized: "key:status_open", table: table)
    static let inProgressStatus = String(localized: "key:status_in_progress", table: table)
    static let contestedStatus = String(localized: "key:status_contested", table: table)
    static let doneStatus = String(localized: "key:status_done", table: table)
    static let todayWithTime = String(localized: "key:today_with_time", table: table)
    static let tomorrowWithTime = String(localized: "key:tomorrow_with_time", table: table)
    static let yesterday = String(localized: "key:yesterday", table: table)
    static func inDays(_ days: Int) -> String {
        let format = String(localized: "key:in_days", table: table)
        return String.localizedStringWithFormat(format, days)
    }
    static func daysAgo(_ days: Int) -> String {
        let format = String(localized: "key:days_ago", table: table)
        return String.localizedStringWithFormat(format, days)
    }
    static func inWeeks(_ weeks: Int) -> String {
        let format = String(localized: "key:in_weeks", table: table)
        return String.localizedStringWithFormat(format, weeks)
    }
    static func weeksAgo(_ weeks: Int) -> String {
        let format = String(localized: "key:weeks_ago", table: table)
        return String.localizedStringWithFormat(format, weeks)
    }
}
