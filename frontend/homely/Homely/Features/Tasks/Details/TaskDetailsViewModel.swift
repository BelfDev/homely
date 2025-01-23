//
//  TaskDetailsViewModel.swift
//  Homely
//
//  Created by Pedro Belfort on 23.01.25.
//

import Foundation

@Observable
final class TaskDetailsViewModel {
    private let homelyClient: HomelyAPIClient
    
    let task: TaskModel
    
    init(_ components: ComponentManager, task: TaskModel) {
        self.homelyClient = components.homelyClient
        self.task = task
    }
    
}
