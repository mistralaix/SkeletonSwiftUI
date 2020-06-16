//
//  Home.swift
//  SkeletonSwifUI
//
//  Created by cyril chaillan on 12/06/2020.
//  Copyright © 2020 Devid. All rights reserved.
//

import SwiftUI

struct Home: View {
    
    @ObservedObject var userVM: UserVM
    @ObservedObject var loginVM: LoginVM
    
    var body: some View {
        ZStack {
            Color.red
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center, spacing: 20) {
                Text("Home")
                Text(self.userVM.user.email!)
                Button(action: {
                    self.loginVM.logout()
                }) {
                    Text("Logout")
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ViewInjector.shared.makeHomePreview()
    }
}
