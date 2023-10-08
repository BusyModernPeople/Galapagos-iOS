//
//  NicknameCheckViewModel.swift
//  Galapagos
//
//  Created by Siri on 2023/10/08.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa

final class NicknameCheckViewModel: ViewModelType {
    struct Input {
        let nickname: Observable<String>
    }
    
    struct Output {
        let certifyNickname: Observable<Bool>
//        let errorMessage: Observable<String>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let certifyResult = Utility.checkNicknameValidation(nickname: input.nickname, validate: .LengthRegex)
        
        
        return Output(
            certifyNickname: certifyResult
        )
    }
}
