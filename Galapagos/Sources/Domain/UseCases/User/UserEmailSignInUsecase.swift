//
//  UserEmailSignInUsecase.swift
//  Galapagos
//
//  Created by Siri on 2023/10/19.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation
import RxSwift

protocol UserEmailSignInUsecase {
	func userEmailSignIn(body: UserEmailSignInBody) -> Single<UserEmailSignInModel>
}
