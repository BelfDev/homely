//
//  ComponentManager.swift
//  Homely
//
//  Created by Pedro Belfort on 22.09.24.
//

import Foundation

@Observable
class ComponentManager {
    let theme: ThemeManager
    let tokenProvider: HomelyAPITokenProvider
    let homelyClient: HomelyAPIClient
    let globalState: GlobalState
    
    init(_ environment: EnvConfig) {
        self.theme = ThemeManager()
        self.tokenProvider = HomelyAPITokenProvider()
        
        tokenProvider.clearToken()
        
        self.homelyClient = HomelyAPIClient(for: environment, with: tokenProvider)
        self.globalState = GlobalState(tokenProvider)
    }
}
