//
//  DefaultUserRepository.swift
//  Galapagos
//
//  Created by Siri on 2023/10/10.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultUserRepository: UserRepository {
	
	private let networkService: NetworkService
	
	init() {
		self.networkService = DefaultNetworkService()
	}
	
	
	func userSignUp(body: UserSignUpBody) -> Single<Data> {
		let endpoint = UserEndpoint.signUp(body: body)
		return networkService.request(endpoint)
	}
	
}
