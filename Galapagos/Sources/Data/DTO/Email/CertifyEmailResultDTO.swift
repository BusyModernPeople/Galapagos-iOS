//
//  CertifyEmailResultDTO.swift
//  Galapagos
//
//  Created by Siri on 2023/10/06.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation


struct CertifyEmailResultDTO: Codable {
    let message: String
    
    func toDomain() -> CertifyCodeResultModel {
        return CertifyCodeResultModel(message: message)
    }
}

