//
//  KeychainManager.swift
//  SkeletonSwifUI
//
//  Created by cyril chaillan on 12/06/2020.
//  Copyright © 2020 Devid. All rights reserved.
//

import Foundation
import KeychainSwift

enum eAuthentMethod: String {
    case email = "email"
    case phone = "phone"
    case facebook = "facebook"
    case apple = "apple"
    case none = "none"
    
    static func convertStringToEnum(_ value: String) -> eAuthentMethod {
        switch value {
        case email.rawValue:
            return email
        case phone.rawValue:
            return phone
        case facebook.rawValue:
            return facebook
        case apple.rawValue:
            return apple
        default:
            return none
        }
    }
}

struct KeychainManager {
    
    static let shared = KeychainManager()
    
    private let keychainSwift = KeychainSwift()
    
    static let UsernameKeychainKey = "USERNAME_KEYCHAIN"
    static let AuthentKeychainKey = "AUTHENT_KEYCHAIN"
    static let PasswordKeychainKey = "PASSWORD_KEYCHAIN"
    
    public func getCredentials() -> (auth: AuthenticationDTO, authenMethod: eAuthentMethod)? {
        guard let username = keychainSwift.get(KeychainManager.UsernameKeychainKey),
            let password = keychainSwift.get(KeychainManager.PasswordKeychainKey),
            let authent = keychainSwift.get(KeychainManager.AuthentKeychainKey) else {
                return nil
        }
        let authentMethod = eAuthentMethod.convertStringToEnum(authent)
        var auth = AuthenticationDTO(password: password)
        if authentMethod == eAuthentMethod.email {
            auth.email = username
        } else if authentMethod == eAuthentMethod.phone {
            auth.phoneNumber = username
        } else if authentMethod == eAuthentMethod.facebook {
            auth.facebookId = username
        } else if authentMethod == eAuthentMethod.apple {
            auth.appleId = username
        }
        return (auth, eAuthentMethod.convertStringToEnum(authent))
    }
    
    public func saveAuthent(authent: AuthenticationDTO, authentMethod: eAuthentMethod) {
        if authentMethod == eAuthentMethod.email {
            self.saveCredentials(authent.email ?? "", password: authent.password, authenMethod: authentMethod)
        } else if authentMethod == eAuthentMethod.phone {
            self.saveCredentials(authent.phoneNumber ?? "", password: authent.password, authenMethod: authentMethod)
        } else if authentMethod == eAuthentMethod.facebook {
            self.saveCredentials(authent.facebookId ?? "", password: authent.password, authenMethod: authentMethod)
        } else if authentMethod == eAuthentMethod.apple {
            self.saveCredentials(authent.appleId ?? "", password: authent.password, authenMethod: authentMethod)
        }
    }
    
    public func saveCredentials(_ username: String, password: String, authenMethod: eAuthentMethod) {
        keychainSwift.set(username, forKey: KeychainManager.UsernameKeychainKey, withAccess: .accessibleAfterFirstUnlock)
        keychainSwift.set(password, forKey: KeychainManager.PasswordKeychainKey, withAccess: .accessibleAfterFirstUnlock)
        keychainSwift.set(authenMethod.rawValue, forKey: KeychainManager.AuthentKeychainKey, withAccess: .accessibleAfterFirstUnlock)
    }
    
    public func clearCredentials() {
        keychainSwift.delete(KeychainManager.UsernameKeychainKey)
        keychainSwift.delete(KeychainManager.PasswordKeychainKey)
        keychainSwift.delete(KeychainManager.AuthentKeychainKey)
    }
    
    private init() {}
}
