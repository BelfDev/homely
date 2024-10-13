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
    
    var greeting: String = ""
    var currentDate: String = ""
    
    init(with components: ComponentManager) {
        self.homelyClient = components.homelyClient
        self.session = components.session
        self.currentDate = getCurrentFormattedDate()
        self.greeting = getGreetingMessage()
    }
    
    func logout() {
        session.logout()
    }
    
    private func getCurrentFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM" // "Thursday, 13 October" format
        return formatter.string(from: Date())
    }
    
    private func getGreetingMessage() -> String {
        return "Morning, \nSofie!"
    }
    
}
