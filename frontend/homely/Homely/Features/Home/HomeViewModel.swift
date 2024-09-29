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
    private let session: SessionManager
    
    init(with components: ComponentManager) {
        self.homelyClient = components.homelyClient
        self.session = components.session
    }
    
    
    func logout() {
        session.logout()
    }
}
