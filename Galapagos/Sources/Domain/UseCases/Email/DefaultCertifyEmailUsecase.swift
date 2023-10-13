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
	
	private let emailRepository: EmailRepository
	
	init(emailRepository: EmailRepository) {
		self.emailRepository = emailRepository
	}
	
	func sendCodeWithEmail(body: SendCodeWithEmailBody) -> Single<CertifyCodeModel> {
		return emailRepository.sendCodeWithEmail(body: body)
			.flatMap { data in
				guard let model = Utility.decode(CertifyCodeModel.self, from: data) else {
					return Single.error(NetworkError.decodingFailed)
				}
				return Single.just(model)
			}
	}
	
	func sendCertifyCode(body: CertifyCodeBody) -> Single<CertifyCodeResultModel> {
		return emailRepository.sendCertifyCode(body: body)
			.flatMap { data in
				guard let model = Utility.decode(CertifyCodeResultModel.self, from: data) else {
					return Single.error(NetworkError.decodingFailed)
				}
				return Single.just(model)
			}
	}
}
