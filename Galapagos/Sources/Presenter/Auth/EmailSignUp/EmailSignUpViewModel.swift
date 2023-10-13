//
//  EmailSignUpViewModel.swift
//  Galapagos
//
//  Created by 조용인 on 2023/06/07.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//
import Foundation

import RxCocoa
import RxSwift

import SiriUIKit
import SnapKit

import UIKit

class EmailSignUpViewModel: ViewModelType{
	
	struct Input {
		let backButtonTapped: Observable<Void>
		let nextButtonTapped: Observable<Void>
		let nowPage: Observable<Int>
	}
	
	struct Output {
		let readyForNextButton: Observable<Bool>
	}
	
	// MARK: - Properties
	private var userSignUpUsecase: UserSignUpUsecase
	
	var disposeBag: DisposeBag = DisposeBag()
	weak var coordinator: AuthCoordinator?
	
	let didTapBackButton = PublishSubject<Void>()
	let readyForNextButton = BehaviorRelay<Bool>(value: false)
	let letsGoSignUp = BehaviorRelay<Bool>(value: false)
	
	var email = BehaviorRelay<String>(value: "")
	var password = BehaviorRelay<String>(value: "")
	var nickname = BehaviorRelay<String>(value: "")
	var socialType = BehaviorRelay<String>(value: "email")
	
	// MARK: - Initializers
	init(
		coordinator: AuthCoordinator,
		userSignUpUsecase: UserSignUpUsecase
	) {
		self.coordinator = coordinator
		self.userSignUpUsecase = userSignUpUsecase
	}
	
	// MARK: - Methods
	func transform(input: Input) -> Output {
		
		input.nextButtonTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.readyForNextButton.accept(false)
			})
			.disposed(by: disposeBag)

		input.backButtonTapped
			.withLatestFrom(input.nowPage.distinctUntilChanged())
			.withUnretained(self)
			.subscribe(onNext: { owner, currentPage in
				print("🍎현재 페이지: \(currentPage)🍎")
				if currentPage == 0 {
					owner.coordinator?.userActionState.accept(.signIn)
				} else {
					owner.readyForNextButton.accept(true)
				}
			})
			.disposed(by: disposeBag)
		
		let signupBody = Observable
			.combineLatest(email, password, nickname, socialType)
			.map{ UserSignUpBody(email: $0, password: $1, nickName: $2, socialType: $3) }
		
		
		// TODO: - 회원가입 시, 에러처리 아직 안함. 그리고, pageScroll 되는 부분도 아직 작성X
		// TODO: - 회원가입 성공 시, JWT 토큰을 UserDefaults에 저장해야함. -> Manager 따로 만들어주기
		
		letsGoSignUp
			.withUnretained(self)
			.filter { $0.1 == true }
			.flatMapLatest { owner, _ in
				signupBody
			}
			.flatMapLatest { [unowned self] body in
				return self.userSignUpUsecase.userSignUp(body: body)
					.catch { error in
						return .error(error)
					}
			}
			.subscribe(onNext: { model in
				UserDefaults.standard.setValue(model.jwt, forKey: "JWT")
				UserDefaults.standard.setValue(model.nickName, forKey: "NICKNAME")
			})
			.disposed(by: disposeBag)
		
		return Output(
			readyForNextButton: readyForNextButton.asObservable()
		)
	}
}
