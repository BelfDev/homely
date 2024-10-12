//
//  Debouncer.swift
//  Homely
//
//  Created by Pedro Belfort on 12.10.24.
//

import Foundation

struct Debouncer {
    private let delay: TimeInterval
    private var lastExecutionTime: Date?

    init(delay: TimeInterval) {
        self.delay = delay
    }

    mutating func execute(action: () -> Void) {
        let now = Date()
        
        if let lastExecution = lastExecutionTime {
            let timeSinceLastExecution = now.timeIntervalSince(lastExecution)
            guard timeSinceLastExecution > delay else { return }
        }

        lastExecutionTime = now
        action()
    }
}
