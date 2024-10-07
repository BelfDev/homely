//
//  SessionManager.swift
//  Homely
//
//  Created by Pedro Belfort on 29.09.24.
//

import Foundation

@Observable
final class SessionManager {
    private let homelyTokenProvider: TokenProviderProtocol
    
    var isLoggedIn: Bool = false
    
    init(_ tokenProvider: TokenProviderProtocol) {
        self.homelyTokenProvider = tokenProvider
        self.isLoggedIn = tokenProvider.hasAccessToken
    }
    
    /**
     Updates the authentication state based on the availability of an access token.
     
     - Note: This method checks whether an access token is present using the `tokenProvider`.
     If an access token exists, the `isLoggedIn` property is set to `true`. Otherwise, it is set to `false`.
     
     - Important: This method is designed to be used as a hook attached to an `onChange` observer.
     It should be called whenever there's a potential change in the access token to ensure the authentication state remains accurate.
     */
    func didChangeAccessToken() {
        isLoggedIn = homelyTokenProvider.hasAccessToken
    }
    
    /**
     Logs out the current user by clearing the stored access token.
     */
    func logout() {
        homelyTokenProvider.clearToken()
    }
}
