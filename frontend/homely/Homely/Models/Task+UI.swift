//
//  Task+UI.swift
//  Homely
//
//  Created by Pedro Belfort on 11.01.25.
//

import SwiftUICore

extension TaskModel {
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
