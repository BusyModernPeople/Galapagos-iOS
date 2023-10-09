//
//  UserEndpoint.swift
//  Galapagos
//
//  Created by Siri on 2023/10/10.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation

enum UserEndpoint: Endpoint {
    case SignUp(body: UserSignUpBody)
    
    var baseURL: URL? {
        return URL(string: "http://3.34.8.109:3040/users")
    }
    
    var method: HTTPMethod {
        switch self {
            case .SignUp:
                return .POST
                
        }
    }
    
    var path: String {
        switch self {
            case .SignUp:
                return "/send-code/signup"
        }
    
    }
    
    var parameters: HTTPRequestParameterType? {
        switch self {
            case .SignUp(let body):
                return .body(body)
        }
    }
}
