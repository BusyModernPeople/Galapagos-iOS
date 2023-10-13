//
//  EmailSignUpViewController.swift
//  Galapagos
//
//  Created by 조용인 on 2023/06/11.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import RxSwift
import UIKit


class EmailSignInViewModel: ViewModelType{
	
	struct Input {}
	
	struct Output {}
	
	var disposeBag: DisposeBag = DisposeBag()
	weak var coordinator: AuthCoordinator?
	
	init(
		coordinator: AuthCoordinator
	) {
		self.coordinator = coordinator
	}
	
	
	func transform(input: Input) -> Output {
		return Output()
	}
	
	
}
