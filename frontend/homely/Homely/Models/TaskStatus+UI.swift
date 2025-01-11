//
//  Task+UI.swift
//  Homely
//
//  Created by Pedro Belfort on 11.01.25.
//

import SwiftUICore

extension TaskStatus {
    var localizedName: String {
        switch self {
        case .opened: return TaskStrings.openStatus
        case .inProgress: return TaskStrings.inProgressStatus
        case .contested: return TaskStrings.contestedStatus
        case .done: return TaskStrings.doneStatus
        }
    }
    
    func color(_ colorTheme: ColorThemeProtocol) -> Color {
        switch self {
        case .opened:
            return colorTheme.secondary
        case .inProgress:
            return colorTheme.tertiary
        case .contested:
            return colorTheme.error
        case .done:
            return colorTheme.primary
        }
    }
}
