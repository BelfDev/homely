//
//  HomeViewModel.swift
//  Homely
//
//  Created by Pedro Belfort on 29.09.24.
//

import Foundation

@Observable
final class HomeViewModel {
    private let homelyClient: HomelyAPIClient
    private let globalState: GlobalState
    
    init(with components: ComponentManager) {
        self.homelyClient = components.homelyClient
        self.globalState = components.globalState
    }
    
    // TODO: Review this
    func logout() {
        homelyClient.logout()
        globalState.isLoggedIn = false
    }
}
