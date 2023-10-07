//
//  PasswordCheckViewModel.swift
//  Galapagos
//
//  Created by Siri on 2023/10/07.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa


final class PasswordCheckViewModel: ViewModelType {
    
    struct Input {
        let password: Observable<String>
        let rePassword: Observable<String>
    }
    
    struct Output {
        let passwordValidations: [Observable<Bool>]
        let firstPasswordCorrect: Observable<Bool>
        let correspondRegex: Observable<Bool>
        let nextAvailable: Observable<Bool>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let passwordValidations: [Observable<Bool>] = [
            .EnglishRegex,
            .NumberRegex,
            .SpecialCharRegex,
            .LengthRegex
        ].map { validate in
            Utility.checkPasswordValidation(password: input.password, validate: validate)
        }
        
        let firstPasswordCorrect = Observable.combineLatest(passwordValidations)
            .map { $0.allSatisfy { $0 } }
        
        let correspondRegex = Observable.combineLatest(input.password, input.rePassword)
            .map { $0 == $1 && $0 != ""}
        
        let nextAvailable = Observable.combineLatest(firstPasswordCorrect, correspondRegex)
            .map { $0 && $1 }
        
        return Output(
            passwordValidations: passwordValidations,
            firstPasswordCorrect: firstPasswordCorrect,
            correspondRegex: correspondRegex,
            nextAvailable: nextAvailable
        )
    }
    
}

