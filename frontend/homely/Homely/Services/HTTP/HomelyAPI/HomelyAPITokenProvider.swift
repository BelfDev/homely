//
//  TokenProvider.swift
//  Homely
//
//  Created by Pedro Belfort on 21.09.24.
//

import Foundation

class HomelyAPITokenProvider: TokenProviderProtocol {
    private(set) var jwtToken: String?
    
    func setToken(_ token: String) {
        self.jwtToken = token
    }

    func clearToken() {
        self.jwtToken = nil
    }

    func refreshToken() async throws -> String {
        // Logic to refresh the token (e.g., re-authenticate or use a refresh token endpoint)
        // For now, we assume a new token is returned.
        let newToken = "newJwtToken"  // Replace with actual refresh logic
        self.jwtToken = newToken
        return newToken
    }
}
