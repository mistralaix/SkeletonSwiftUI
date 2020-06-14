//
//  ContentView.swift
//  SkeletonSwifUI
//
//  Created by cyril chaillan on 12/06/2020.
//  Copyright © 2020 Devid. All rights reserved.
//

import SwiftUI

struct SplashView: View {
    
    @ObservedObject var loginVM: LoginVM
    
    @State private var _showLogin: Bool = false
    @State private var _showHome: Bool = false
    @State private var _isLoading: Bool = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black
                .edgesIgnoringSafeArea(.all)
            ActivityIndicator(isAnimating: $_isLoading, style: .medium).padding()
            if self._showLogin {
                ViewInjector.shared.makeLogin()
            } else if self._showHome {
                ViewInjector.shared.makeHome()
            }
        }
        .onReceive(self.loginVM.$authentState) { newValue in
            DispatchQueue.main.async {
                withAnimation {
                    self._showLogin = newValue == .unauthent
                    self._showHome = newValue == .dataLoaded
                }
            }
        }
        .onReceive(self.loginVM.$isLoading) { newValue in
            self._isLoading = newValue
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        ViewInjector.shared.makeSplash()
    }
}
