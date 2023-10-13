//
//  UserEndpoint.swift
//  Galapagos
//
//  Created by Siri on 2023/10/10.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation

enum UserEndpoint: Endpoint {
	case signUp(body: UserSignUpBody)
	
	var baseURL: URL? {
		return URL(string: "http://3.34.8.109:3040/users")
	}
	
	var method: HTTPMethod {
		switch self {
		case .signUp:
			return .POST
			
		}
	}
	
	var path: String {
		switch self {
		case .signUp:
			return "/send-code/signup"
		}
		
	}
	
	var parameters: HTTPRequestParameterType? {
		switch self {
		case .signUp(let body):
			return .body(body)
		}
	}
}
