//
//  UserEmailSignInBody.swift
//  Galapagos
//
//  Created by Siri on 2023/10/19.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation

struct UserEmailSignInBody: Codable {
	let email: String
	let password: String
}
