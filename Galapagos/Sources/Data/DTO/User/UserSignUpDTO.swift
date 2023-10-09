//
//  UserSignUpDTO.swift
//  Galapagos
//
//  Created by Siri on 2023/10/10.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation

struct UserSignUpDTO: Codable {
    let userIdx: String
    let nickName: String
    let jwt: String
    
    
    func toModel() -> UserSignUpModel {
        return UserSignUpModel(
            nickName: nickName,
            jwt: jwt
        )
    }

}

