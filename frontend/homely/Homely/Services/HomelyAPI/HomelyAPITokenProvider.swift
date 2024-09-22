//
//  HomelyAPITokenProvider.swift
//  Homely
//
//  Created by Pedro Belfort on 21.09.24.
//

import Foundation

class HomelyAPITokenProvider: TokenProviderProtocol {
    private let tokenKey = "HomelyJWTToken"
    
    // Thread-safe access to the JWT token using a serial dispatch queue
    private let tokenAccessQueue = DispatchQueue(label: "com.homely.tokenAccessQueue")
    
    // Store the JWT token in memory for quick access
    private var memoryCachedToken: String?
    
    var jwtToken: String? {
        get {
            return tokenAccessQueue.sync {
                if let cachedToken = memoryCachedToken {
                    return cachedToken
                }
                let token = loadTokenFromKeychain()
                memoryCachedToken = token
                return token
            }
        }
    }
    
    /**
     Sets a new JWT token and stores it in secure storage (Keychain).

     - Parameter token: The new JWT token to set.
     - Throws: `KeychainError.unableToSave` if the token could not be saved to the Keychain.
     */
    func setToken(_ token: String) throws {
        try tokenAccessQueue.sync {
            self.memoryCachedToken = token
            try saveTokenToKeychain(token: token)
        }
    }
    
    /**
     Clears the current JWT token from both memory and secure storage.
     */
    func clearToken() {
        tokenAccessQueue.sync {
            self.memoryCachedToken = nil
            deleteTokenFromKeychain()
        }
    }
    
    /**
     Simulates a token refresh, but instead of refreshing, it clears the token to simulate an expired session.
     
     - Throws: A custom error indicating that the token needs to be refreshed (i.e., user must log in again).
     */
    @MainActor
    func refreshToken() async throws -> String {
        // TODO(BelfDev): Upgrade the App to use Refresh Tokens.
        clearToken()
        throw APIError.unauthorized  // `APIError.unauthorized` is how we handle token expiration. We expect users to be forwarded to the Login Screen.
    }
}

// MARK: - Keychain Storage

extension HomelyAPITokenProvider {
        
    private func saveTokenToKeychain(token: String) throws {
        let tokenData = Data(token.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey,
            kSecValueData as String: tokenData
        ]
        SecItemDelete(query as CFDictionary)  // Delete existing token if present
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unableToSave
        }
    }
    
    private func loadTokenFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let tokenData = item as? Data else {
            return nil
        }
        
        return String(data: tokenData, encoding: .utf8)
    }
    
    private func deleteTokenFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey
        ]
        SecItemDelete(query as CFDictionary)
    }
}
