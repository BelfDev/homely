//
//  LocalStoreManager.swift
//  Homely
//
//  Created by Pedro Belfort on 12.10.24.
//

import Security
import Foundation

actor LocalStoreManager {
    
    private let lastUsedEmailKey = "lastUsedEmailKey"
    
    /// Save credentials (email and password) to Keychain
    func saveCredentials(email: String, password: String) -> Bool {
        guard let passwordData = password.data(using: .utf8) else { return false }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email,
            kSecValueData as String: passwordData
        ]
        
        SecItemDelete(query as CFDictionary) // Delete any existing items before adding
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        // Save the last used email separately in UserDefaults
        if status == errSecSuccess {
            UserDefaults.standard.set(email, forKey: lastUsedEmailKey)
        }
        
        return status == errSecSuccess
    }
    
    /// Retrieve credentials (password) for a given email
    func getCredentials(for email: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess, let passwordData = item as? Data else { return nil }
        return String(data: passwordData, encoding: .utf8)
    }
    
    /// Retrieve the last email used for login from UserDefaults
    func getLastUsedEmail() -> String? {
        return UserDefaults.standard.string(forKey: lastUsedEmailKey)
    }
    
    /// Delete credentials for a given email
    func deleteCredentials(for email: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
