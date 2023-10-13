//
//  SignInViewModel.swift
//  Galapagos
//
//  Created by 조용인 on 2023/06/07.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//
import Foundation

import RxCocoa
import RxSwift

class SignInViewModel: ViewModelType{
	
	struct Input {
		let emailSignUpBtnTapped: Observable<Void>
		let emailSignInBtnTapped: Observable<Void>
		let googleSignInBtnTapped: Observable<Void>
		
		
	}
	
	struct Output {}
	
	var disposeBag: DisposeBag = DisposeBag()
	
	//  private let socialCreateUsecase: SocialUserCreateUseCase
	weak var coordinator: AuthCoordinator?
	
	init(
		coordinator: AuthCoordinator
		//    socialCreateUsecase: SocialUserCreateUseCase
	) {
		self.coordinator = coordinator
		//    self.socialCreateUsecase = socialCreateUsecase
	}
	
	
	func transform(input: Input) -> Output {
		input.emailSignUpBtnTapped.subscribe(onNext: {
			[weak self] _ in
			guard let self = self else {return}
			self.coordinator?.userActionState.accept(.emailSignUp)
		}).disposed(by: disposeBag)
		
		input.emailSignInBtnTapped.subscribe(onNext: {
			[weak self] _ in
			guard let self = self else {return}
			self.coordinator?.userActionState.accept(.emailSignIn)
		}).disposed(by: disposeBag)
		
		return Output()
	}
	
	//  func requestGoogleLogin(result: GIDSignInResult?) {
	//    
	//  }
	
}
