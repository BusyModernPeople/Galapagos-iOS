//
//  DefaultUserSignUpUsecase.swift
//  Galapagos
//
//  Created by Siri on 2023/10/10.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultUserSignUpUsecase: UserSignUpUsecase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func userSignUp(body: UserSignUpBody) -> Single<UserSignUpModel> {
        return userRepository.userSignUp(body: body)
            .flatMap { data in
                guard let model = Utility.decode(UserSignUpModel.self, from: data) else {
                    return Single.error(NetworkError.decodingFailed)
                }
                return Single.just(model)
            }
    }
    
}

