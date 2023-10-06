//
//  DefaultEmailRepositoty.swift
//  Galapagos
//
//  Created by Siri on 2023/10/06.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultEmailRepository: EmailRepository {
    
    private let networkService: NetworkService
    
    init() {
        self.networkService = DefaultNetworkService()
    }
    
    func sendCodeWithEmail(body: SendCodeWithEmailBody) -> Single<CertifyCodeModel> {
        let endpoint = EmailEndpoint.sendCodeWithEmail(body: body)
        return networkService.request(endpoint, decodeTo: CertifyCodeModel.self)
    }

    func sendCertifyCode(body: CertifyCodeBody) -> Single<CertifyCodeResultModel> {
        let endpoint = EmailEndpoint.certifyCode(body: body)
        return networkService.request(endpoint, decodeTo: CertifyCodeResultModel.self)
    }


}
