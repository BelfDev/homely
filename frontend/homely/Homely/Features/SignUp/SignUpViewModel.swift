//
//  SignUpViewModel.swift
//  Homely
//
//  Created by Pedro Belfort on 08.10.24.
//

import Foundation

@Observable
final class SignUpViewModel {
    private let homelyClient: HomelyAPIClient
    
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var password: String = ""
    
    init(with components: ComponentManager) {
        self.homelyClient = components.homelyClient
    }
    
    @MainActor
    func signUp() {
        
    }
}
