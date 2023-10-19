//
//  DefaultUserEmailSignInUsecase.swift
//  Galapagos
//
//  Created by Siri on 2023/10/19.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultUserEmailSignInUsecase: UserEmailSignInUsecase {
	
	private let userRepository: UserRepository
	
	init(userRepository: UserRepository) {
		self.userRepository = userRepository
	}
	
	func userEmailSignIn(body: UserEmailSignInBody) -> Single<UserEmailSignInModel> {
		return userRepository.userEmailSignIn(body: body)
			.flatMap { data in
				guard let model = Utility.decode(UserEmailSignInModel.self, from: data) else {
					return Single.error(NetworkError.decodingFailed)
				}
				return Single.just(model)
			}
	}
	
}
