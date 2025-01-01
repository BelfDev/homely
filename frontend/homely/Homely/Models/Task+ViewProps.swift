//
//  Task+ViewProps.swift
//  Homely
//
//  Created by Pedro Belfort on 01.01.25.
//

import SwiftUICore

extension TaskStatus {
    var color: Color {
        switch self {
        case .opened: return.gray
        case .inProgress: return .orange
        case .contested: return .red
        case .done: return .green
        }
    }
}
