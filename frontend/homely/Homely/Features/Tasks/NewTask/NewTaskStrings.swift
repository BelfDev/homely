//
//  NewTaskStrings.swift
//  Homely
//
//  Created by Pedro Belfort on 18.01.25.
//

import SwiftUI

struct NewTaskStrings {
    private static let table = "NewTaskScreen"
    
    static let screenTitle = String(localized: "key:new_task_screen_title", table: table)
    static let titleInputLabel = String(localized: "key:input_label_title", table: table)
    static let descriptionInputLabel = String(localized: "key:input_label_description", table: table)
    static let startAtInputLabel = String(localized: "key:input_label_start_at", table: table)
    static let endAtInputLabel = String(localized: "key:input_label_end_at", table: table)
    static let createTaskButton = String(localized: "key:new_task_button", table: table)
}

