//
//  KeyChainManager.swift
//  Galapagos
//
//  Created by 조용인 on 2023/05/23.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import KeychainSwift

class UserManager {
	static let shared = UserManager()
	
	var accessToken: String {
		get {
			return KeychainSwift().get("accessToken") ?? ""
		}
		set {
			KeychainSwift().set(newValue, forKey: "accessToken")
		}
	}
	var refreshToken: String {
		get {
			return KeychainSwift().get("refreshToken") ?? ""
		}
		set {
			KeychainSwift().set(newValue, forKey: "refreshToken")
		}
	}
	
	private init() {}
}
