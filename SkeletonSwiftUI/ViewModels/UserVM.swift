//
//  UserVM.swift
//  SkeletonSwifUI
//
//  Created by cyril chaillan on 12/06/2020.
//  Copyright © 2020 Devid. All rights reserved.
//

import Foundation
import Combine

final class UserVM: ObservableObject  {
    
    @Published var isLoading = false
    @Published var user: UserDTO
    
    init(user: UserDTO) {
        self.user = user
    }

}
