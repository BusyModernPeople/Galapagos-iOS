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
	case emailSignIn(body: UserEmailSignInBody)
	
	var baseURL: URL? {
		return URL(string: "http://3.34.8.109:3040/users")
	}
	
	var method: HTTPMethod {
		switch self {
		case .signUp, .emailSignIn:
			return .POST
			
		}
	}
	
	var path: String {
		switch self {
		case .signUp:
			return "/signup"
		case .emailSignIn:
			return "/email-login"
		}
		
	}
	
	var parameters: HTTPRequestParameterType? {
		switch self {
		case .signUp(let body):
			return .body(body)
		case .emailSignIn(let body):
			return .body(body)
		}
	}
}
