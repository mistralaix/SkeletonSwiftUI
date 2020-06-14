//
//  LoginViewModel.swift
//  SkeletonSwifUI
//
//  Created by cyril chaillan on 12/06/2020.
//  Copyright © 2020 Devid. All rights reserved.
//

import Foundation
import Combine

final class LoginVM: ObservableObject  {
    
    @Published var isLoading = false
    @Published var authentState: eAuthenticationState
    @Published var loginState: Event<eLoginState>?
    
    enum eAuthenticationState {
        case authent
        case unauthent
        case dataLoaded
    }
    
    enum eLoginState {
        case loginError
        case loginSuccess
    }
    
    init() {
        authentState = KeychainManager.shared.getCredentials() == nil ? .unauthent : .authent
        if authentState == .authent {
            self.getSplashData()
        }
    }
    
    func login(auth: AuthenticationDTO, authMethod: eAuthentMethod) {
        self.isLoading = true
        WebService.shared.authenticate(authent: auth, authentMethod: authMethod) { (object, response, err) in
            self.isLoading = false
            if let obj = object, response.isSuccess {
                AppDataManager.shared.user = obj.user
                ViewInjector.shared.initUserVM(user: obj.user)
                self.loginState = Event(content: .loginSuccess)
                self.authentState = .authent
                self.getSplashData()
            } else {
                self.loginState = Event(content: .loginError)
            }
        }
    }
    
    func logout() {
        self.authentState = .unauthent
    }
    
    func getSplashData() {
        if (KeychainManager.shared.getCredentials() != nil) {
            isLoading = true
            AppDataManager.shared.getData { user in
                self.isLoading = false
                guard let user = user else {
                    self.authentState = .unauthent
                    return
                }
                ViewInjector.shared.initUserVM(user: user)
                self.authentState = .dataLoaded
            }
        } else {
            authentState = .unauthent
        }
    }

}
