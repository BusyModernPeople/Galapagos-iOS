//
//  UserEmailSignInDTO.swift
//  Galapagos
//
//  Created by Siri on 2023/10/19.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation

struct UserEmailSignInDTO: Codable {
	let userIdx: String
	let nickName: String
	let jwt: String
	
	func toModel() -> UserEmailSignInModel {
		return UserEmailSignInModel(
			nickName: nickName,
			jwt: jwt
		)
	}
	
}
