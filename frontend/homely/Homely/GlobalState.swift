//
//  GlobalState.swift
//  Homely
//
//  Created by Pedro Belfort on 29.09.24.
//

import Foundation

@Observable
final class GlobalState {
    
    var isLoggedIn: Bool
    
    init(_ tokenProvider: HomelyAPITokenProvider) {
        self.isLoggedIn = tokenProvider.hasAccessToken
    }
}
