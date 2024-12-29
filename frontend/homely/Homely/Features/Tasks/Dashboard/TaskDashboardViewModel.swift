//
//  TaskDashboardViewModel.swift
//  Homely
//
//  Created by Pedro Belfort on 29.12.24.
//

import Foundation

final class TaskDashboardViewModel {
    private let homelyClient: HomelyAPIClient
    
    init(with components: ComponentManager) {
        self.homelyClient = components.homelyClient
    }
        
}
