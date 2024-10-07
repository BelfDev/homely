//
//  ComponentManager.swift
//  Homely
//
//  Created by Pedro Belfort on 22.09.24.
//

import Foundation

@Observable
final class ComponentManager {
    let theme: ThemeManager
    let tokenProvider: HomelyAPITokenProvider
    let homelyClient: HomelyAPIClient
    let session: SessionManager
    
    init(_ environment: EnvConfig) {
        self.theme = ThemeManager()
        self.tokenProvider = HomelyAPITokenProvider()
        self.homelyClient = HomelyAPIClient(for: environment, with: tokenProvider)
        self.session = SessionManager(tokenProvider)
    }
}
