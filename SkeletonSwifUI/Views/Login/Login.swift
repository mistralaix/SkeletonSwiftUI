//
//  Login.swift
//  SkeletonSwifUI
//
//  Created by cyril chaillan on 12/06/2020.
//  Copyright © 2020 Devid. All rights reserved.
//

import SwiftUI

struct Login: View {
    
    @State private var _email: String = ""
    @State private var _password: String = ""
    @State private var _isLoading: Bool = false
    
    @ObservedObject var loginVM: LoginVM
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.yellow
                .edgesIgnoringSafeArea(.all)
            ActivityIndicator(isAnimating: self.$_isLoading, style: .medium).padding()
            VStack(alignment: .center, spacing: 15) {
                Spacer()
                TextField("Email", text: self.$_email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Password", text: self.$_password).textContentType(.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    self.loginVM.login(auth: AuthenticationDTO(email: "cyril@test.com", password: "password"), authMethod: .email)
//                    self._loginVM.login(auth: AuthenticationDTO(email: self._email, password: self._password), authMethod: .email)
                }) {
                    Text("Login")
                }
                    Spacer()
                .onReceive(self.loginVM.$isLoading) { (isLoading) in
                    print("Loading --> \(isLoading)")
                    self._isLoading = isLoading
                }
                .onReceive(self.loginVM.$loginState) { (loginState) in
                    guard let state = loginState?.getContentIfNotHandled() else { return }
                    switch state {
                    case .loginError:
                        print("------------> Login error")
                    case .loginSuccess:
                        print("------------> Login success")
                    }
                }
            }.padding()
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        ViewInjector.shared.makeLogin()
    }
}
