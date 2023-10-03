//
//  AuthEndpoint.swift
//  Galapagos
//
//  Created by Siri on 2023/10/04.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation

enum AuthEndpoint: Endpoint {
    case certifyEmail
    
    
    var baseURL: URL?
    
    var method: HTTPMethod
    
    var path: String
    
    var parameters: HTTPRequestParameterType?
    
    
}
