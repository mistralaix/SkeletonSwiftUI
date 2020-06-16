//
//  ViewModelBuilder.swift
//  SkeletonSwifUI
//
//  Created by cyril chaillan on 14/06/2020.
//  Copyright © 2020 Devid. All rights reserved.
//

import Foundation
import SwiftUI

class ViewInjector {
    
    static let shared = ViewInjector()
    
    private var _loginVM: LoginVM = LoginVM()
    private var _userVM: UserVM?
    
    func initUserVM(user: UserDTO) {
        self._userVM = UserVM(user: user)
    }
    
}

extension ViewInjector {
    
    func makeLogin() -> some View {
        return Login(loginVM: self._loginVM)
    }
    
    func makeSplash() -> some View {
        return SplashView(loginVM: self._loginVM)
    }
    
    func makeHome() -> some View {
        guard let userVM = self._userVM else { fatalError("UserVM not provided") }
        return Home(userVM: userVM, loginVM: self._loginVM)
    }
    
}

// MARK: For preview that needs a viewModel initialisation
extension ViewInjector {
    func makeHomePreview() -> some View {
        return Home(userVM: UserVM(user: UserDTO(_id: "1234567890", email: "test@test.com")), loginVM: self._loginVM)
    }
}
