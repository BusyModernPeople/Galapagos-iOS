//
//  UserSignUpBody.swift
//  Galapagos
//
//  Created by Siri on 2023/10/10.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation

struct UserSignUpBody: Codable {
    let email: String
    let password: String
    let nickName: String
    let socialType: String
}
