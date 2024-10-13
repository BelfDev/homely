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
    
    var currentDate: String = ""
    
    init(with components: ComponentManager) {
        self.homelyClient = components.homelyClient
        self.session = components.session
        self.currentDate = getCurrentFormattedDate()
    }
    
    func logout() {
        session.logout()
    }
    
    private func getCurrentFormattedDate() -> String {
          let formatter = DateFormatter()
          formatter.dateFormat = "EEEE, d MMMM" // "Thursday, 13 October" format
          return formatter.string(from: Date())
      }
}
