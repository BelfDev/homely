//
//  TaskStatus.swift
//  Homely
//
//  Created by Pedro Belfort on 11.01.25.
//

import Foundation

enum TaskStatus: String, Codable, CaseIterable {
    case opened = "OPENED"
    case inProgress = "IN_PROGRESS"
    case contested = "CONTESTED"
    case done = "DONE"
}
