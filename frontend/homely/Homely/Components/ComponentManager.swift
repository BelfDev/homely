//
//  ComponentManager.swift
//  Homely
//
//  Created by Pedro Belfort on 22.09.24.
//

import Foundation

@Observable
class ComponentManager {
    let homelyClient: HomelyAPIClient
    let theme: ThemeManager
    
    init(_ environment: EnvConfig) {
        self.homelyClient = HomelyAPIClient(for: environment)
        self.theme = ThemeManager()
    }
}
