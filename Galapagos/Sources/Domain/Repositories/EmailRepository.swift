//
//  EmailRepository.swift
//  Galapagos
//
//  Created by Siri on 2023/10/06.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation
import RxSwift

protocol EmailRepository {
    func sendCodeWithEmail(body: SendCodeWithEmailBody) -> Single<CertifyCodeModel>
    func sendCertifyCode(body: CertifyCodeBody) -> Single<CertifyCodeResultModel>
}
