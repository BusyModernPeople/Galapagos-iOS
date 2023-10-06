//
//  DefaultCertifyCodeWithEmailUsecase.swift
//  Galapagos
//
//  Created by Siri on 2023/10/04.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation
import RxSwift


class DefaultCertifyCodeWithEmailUsecase: CertifyEmailUsecase {
    
    private let authRepository: EmailRepository
    
    init(authRepository: EmailRepository) {
        self.authRepository = authRepository
    }
    
    func sendCodeWithEmail(body: SendCodeWithEmailBody) -> Single<String> {
        return authRepository.sendCodeWithEmail(body: body)
            .map { $0.message }
    }
    
    func sendCertifyCode(body: CertifyCodeBody) -> Single<String> {
        return authRepository.sendCertifyCode(body: body)
            .map { $0.message }
    }
}
