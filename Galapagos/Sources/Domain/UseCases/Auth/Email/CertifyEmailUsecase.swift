//
//  CertifyEmailUsecase.swift
//  Galapagos
//
//  Created by Siri on 2023/10/04.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation
import RxSwift

protocol CertifyEmailUsecase {
    func sendCodeWithEmail(body: SendCodeWithEmailBody) -> Single<String>
    func sendCertifyCode(body: CertifyCodeBody) -> Single<String>
}

