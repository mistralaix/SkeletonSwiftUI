//
//  DTO.swift
//  SkeletonSwifUI
//
//  Created by cyril chaillan on 12/06/2020.
//  Copyright © 2020 Devid. All rights reserved.
//

import Foundation
import UIKit

struct ErrorResponseDTO: Decodable {
}

struct LoginDTO: Decodable {
    let token: String
    let user: UserDTO
}

struct AuthenticationDTO: Encodable {
    var email: String? = nil
    let password: String
}

struct UserDTO: Codable {
    let _id: String
    let email: String?
}

struct FileWrapperDto {
    let fileName: String
    let fileNameField: String
    let data: Data
}

struct NotificationTokenDTO: Encodable {
    let token: String
    let type: String = "IOS"
}
