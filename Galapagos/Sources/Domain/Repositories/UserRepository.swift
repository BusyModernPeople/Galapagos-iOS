//
//  UserRepository.swift
//  Galapagos
//
//  Created by Siri on 2023/10/10.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation
import RxSwift

protocol UserRepository {
	func userSignUp(body: UserSignUpBody) -> Single<Data>
}
