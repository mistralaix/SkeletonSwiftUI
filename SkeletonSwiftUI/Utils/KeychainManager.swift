//
//  KeychainManager.swift
//  SkeletonSwifUI
//
//  Created by cyril chaillan on 12/06/2020.
//  Copyright © 2020 Devid. All rights reserved.
//

import Foundation
import KeychainSwift

struct KeychainManager {
    
    static let shared = KeychainManager()
    
    private let keychainSwift = KeychainSwift()
    
    static let EmailKeychainKey = "SKELETON_EMAIL_KEYCHAIN"
    static let PasswordKeychainKey = "SKELETON_PASSWORD_KEYCHAIN"
    static let TokenKeychainKey = "SKELETON_TOKEN_KEYCHAIN"
    
    public func getCredentials() -> (email: String, password: String)? {
        guard let email = keychainSwift.get(KeychainManager.EmailKeychainKey),
            let password = keychainSwift.get(KeychainManager.PasswordKeychainKey) else {
                return nil
        }
        return (email, password)
    }
    
    public func getToken() -> String? {
        return keychainSwift.get(KeychainManager.TokenKeychainKey)
    }
    
    public func saveCredentials(email: String, password: String, token: String) {
        keychainSwift.set(email, forKey: KeychainManager.EmailKeychainKey, withAccess: .accessibleAfterFirstUnlock)
        keychainSwift.set(password, forKey: KeychainManager.PasswordKeychainKey, withAccess: .accessibleAfterFirstUnlock)
        keychainSwift.set(token, forKey: KeychainManager.TokenKeychainKey, withAccess: .accessibleAfterFirstUnlock)
    }
    
    public func clearCredentials() {
        keychainSwift.delete(KeychainManager.EmailKeychainKey)
        keychainSwift.delete(KeychainManager.PasswordKeychainKey)
        keychainSwift.delete(KeychainManager.TokenKeychainKey)
    }
    
}
