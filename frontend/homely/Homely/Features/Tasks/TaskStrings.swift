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
}

