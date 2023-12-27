//
//  SignUpViewModel.swift
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

class SignUpViewModel: ViewModelType{
	
	struct Input {
		let backButtonTapped: Observable<Void>
		let nextButtonTapped: Observable<Void>
		let nowPage: Observable<Int>
	}
	
	struct Output {
		let readyForNextButton: Observable<Bool>
		let nextButtonHidden: Observable<Bool>
		let backButtonHidden: Observable<Bool>
		let moveToComplete: Observable<Bool>
	}
	
	// MARK: - Properties
	private var authUsecase: AuthUsecase
	
	var disposeBag: DisposeBag = DisposeBag()
	weak var coordinator: AuthCoordinator?
	
	let readyForNextButton = BehaviorRelay<Bool>(value: false)
	let letsGoSignUp = BehaviorRelay<Bool>(value: false)
	
	private let nextButtonHidden = BehaviorSubject<Bool>(value: false)
	private let backButtonHidden = BehaviorSubject<Bool>(value: false)
	private let moveToNext = BehaviorSubject<Bool>(value: false)
	
	var email = BehaviorRelay<String>(value: "")
	var password = BehaviorRelay<String>(value: "")
	var nickname = BehaviorRelay<String>(value: "")
	var socialType = BehaviorRelay<String>(value: "email")
	
	// MARK: - Initializers
	init(
		coordinator: AuthCoordinator,
		authUsecase: AuthUsecase
	) {
		self.coordinator = coordinator
		self.authUsecase = authUsecase
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
				if currentPage == 0 {
					owner.coordinator?.popViewController(animated: true)
				} else {
					owner.readyForNextButton.accept(true)
				}
			})
			.disposed(by: disposeBag)
		
		input.nowPage
			.withUnretained(self)
			.subscribe(onNext: { owner, page in
				owner.nextButtonHidden.onNext(page >= 3)
				owner.backButtonHidden.onNext(page >= 4)
			})
			.disposed(by: disposeBag)
		
		
		
		let signupBody = Observable
			.combineLatest(email, password, nickname, socialType)
			.map{ 
				SignUpBody(email: $0, password: $1, nickName: $2, socialType: $3)
			}
		
		letsGoSignUp
			.withUnretained(self)
			.filter { $0.1 == true }
			.flatMapLatest { owner, _ in
				signupBody
			}
			.withUnretained(self)
			.flatMapLatest { owner, body in
				return owner.authUsecase.signUp(body: body)
					.catch { error in
						return .error(error)
					}
			}
			.withUnretained(self)
			.subscribe(onNext: { owner, model in
				UserDefaultManager.shared.save(model.jwt, for: .jwt)
				UserDefaultManager.shared.save(model.nickName, for: .nickName)
				owner.moveToNext.onNext(true)
			})
			.disposed(by: disposeBag)
		
		return Output(
			readyForNextButton: readyForNextButton.asObservable(),
			nextButtonHidden: nextButtonHidden.asObservable(),
			backButtonHidden: backButtonHidden.asObservable(),
			moveToComplete: moveToNext.asObservable()
		)
	}
}
