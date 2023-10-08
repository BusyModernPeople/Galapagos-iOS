//
//  ValidationCase.swift
//  Galapagos
//
//  Created by Siri on 2023/10/07.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation

enum PasswordValidate {
    
    case EnglishRegex
    case NumberRegex
    case SpecialCharRegex
    case LengthRegex
    
    var validate: String {
        switch self {
        case .EnglishRegex:
            return ".*[A-Za-z]+.*"
        case .NumberRegex:
            return ".*[0-9]+.*"
        case .SpecialCharRegex:
            return ".*[!@#$%^&*()_+{}:<>?]+.*"
        case .LengthRegex:
            return "^.{8,20}$"
        }
    }
}

enum NicknameValidate {
    case LengthRegex
    
    var validate: String {
        switch self {
        case .LengthRegex:
            return "^.{2,6}$"
        }
    }
}
