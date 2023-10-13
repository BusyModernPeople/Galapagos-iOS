//
//  NicknameCheckViewModel.swift
//  Galapagos
//
//  Created by Siri on 2023/10/08.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//
import Foundation

import RxCocoa
import RxSwift

import SnapKit

import UIKit

final class NicknameCheckViewModel: ViewModelType {
	struct Input {
		let nickname: Observable<String>
		let completeBtnTapped: Observable<Void>
	}
	
	struct Output {
		let certifyNickname: Observable<Bool>
		//        let errorMessage: Observable<String>
		let letsSignUp: Observable<Void>
	}
	
	var disposeBag: DisposeBag = DisposeBag()
	
	func transform(input: Input) -> Output {
		let certifyResult = Utility.checkNicknameValidation(nickname: input.nickname, validate: .lengthRegex)
		
		
		return Output(
			certifyNickname: certifyResult,
			letsSignUp: input.completeBtnTapped
		)
	}
}
