//
//  PasswordCheckViewModel.swift
//  Galapagos
//
//  Created by Siri on 2023/10/07.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//
import Foundation

import RxCocoa
import RxSwift

import UIKit


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
			.englishRegex,
			.numberRegex,
			.specialCharRegex,
			.lengthRegex
		].map({validate in
			Utility.checkPasswordValidation(password: input.password, validate: validate)
		})
		
		let firstPasswordCorrect = Observable.combineLatest(passwordValidations)
			.map { $0.allSatisfy { $0 } }
		
		let correspondRegex = Observable.combineLatest(input.password, input.rePassword)
			.map { $0 == $1 && !$0.isEmpty}
		
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
