//
//  EmailSignUpViewController.swift
//  Galapagos
//
//  Created by 조용인 on 2023/06/11.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//
import Foundation

import RxCocoa
import RxSwift

class EmailSignInViewModel: ViewModelType{
	
	struct Input {
		let email: Observable<String>
		let password: Observable<String>
		let backBtnTapped: Observable<Void>
		let resettingPasswordBtnTapped: Observable<Void>
		let signInBtnTapped: Observable<Void>
	}
	
	struct Output {
		let signInBtnEnable: Observable<Bool>
	}
	
	var disposeBag: DisposeBag = DisposeBag()
	weak var coordinator: AuthCoordinator?
	private let userEmailSignInUsecase: UserEmailSignInUsecase
	
	init(
		coordinator: AuthCoordinator,
		userEmailSignInUsecase: UserEmailSignInUsecase
	) {
		self.coordinator = coordinator
		self.userEmailSignInUsecase = userEmailSignInUsecase
	}
	
	
	func transform(input: Input) -> Output {
		let signInBtnEnable = Observable.combineLatest(input.email, input.password)
			.map { email, password in
				return !email.isEmpty && !password.isEmpty
			}
		
		input.signInBtnTapped
			.withLatestFrom(Observable.combineLatest(input.email, input.password))
			.flatMapLatest { [weak self] email, password -> Observable<Result<UserEmailSignInModel, Error>> in
				guard let self = self else { return .empty() }
				let body = UserEmailSignInBody(email: email, password: password)
				return self.userEmailSignInUsecase.userEmailSignIn(body: body)
					.map { Result.success($0) }
					.catch { error in
						// TODO: 로그인 실패 알림 로직
						// 예: 사용자에게 알럿을 띄우거나 토스트 메시지를 보여줌
						return .just(Result.failure(error))
					}
					.asObservable()
			}
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { [weak self] result in
				switch result {
				case .success(let model):
					UserDefaults.standard.setValue(model.jwt, forKey: "JWT")
					UserDefaults.standard.setValue(model.nickName, forKey: "NICKNAME")
					print("🍎 발급받은 JWT: \(model.jwt) 🍎")
					self?.coordinator?.finish()
				case .failure(let error):
					print("🍎 발생한 에러: \(error) 🍎")
					// 여기서 사용자에게 로그인 실패를 알림
				}
			})
			.disposed(by: disposeBag)
		
		input.backBtnTapped
			.withUnretained(self)
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.popViewController()
			})
			.disposed(by: disposeBag)
		
		return Output(
			signInBtnEnable: signInBtnEnable
		)
	}
	
	
}
