//
//  EmailCheckViewModel.swift
//  Galapagos
//
//  Created by Siri on 2023/10/02.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift


final class EmailCheckViewModel: ViewModelType {
	
	struct Input {
		
	}
	
	struct Output {
		let certifyCodeIsHidden: Observable<Bool>
		let nextButtonIsAvailable: Observable<Bool>
	}
	
	var disposeBag: DisposeBag = DisposeBag()
	
	var certifyCodeIsHidden = BehaviorRelay<Bool>(value: true)
	var nextButtonIsAvailable = BehaviorRelay<Bool>(value: false)
	var userEmail = BehaviorRelay<String>(value: "")
	
	func transform(input: Input) -> Output {
		
		return Output(
			certifyCodeIsHidden: certifyCodeIsHidden.asObservable(),
			nextButtonIsAvailable: nextButtonIsAvailable.asObservable()
		)
	}
}
