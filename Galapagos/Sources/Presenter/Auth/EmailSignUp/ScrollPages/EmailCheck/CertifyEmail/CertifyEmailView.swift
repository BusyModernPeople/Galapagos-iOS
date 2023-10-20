//
//  CertifyEmailView.swift
//  Galapagos
//
//  Created by Siri on 2023/10/02.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import SiriUIKit
import UIKit



final class CertifyEmailView: BaseView {
	
	// MARK: - UI Components
	
	public lazy var emailTextField: GalapagosTextField = {
		let textField = GalapagosTextField(
			placeHolder: "이메일을 입력해주세요",
			maxCount: 0
		)
		return textField
	}()
	
	public lazy var errorMessage: GalapagosErrorMessage = {
		let errorMessage = GalapagosErrorMessage(
			title: "",
			type: .none
		)
		return errorMessage
	}()
	
	public lazy var certifyEmailButton: GalapagosButton = {
		let button = GalapagosButton(
			isRound: false,
			iconTitle: nil,
			type: .usage(.disabled),
			title: "이메일 인증하기"
		)
		return button
	}()
	
	// MARK: - Properties
	private let viewModel: CertifyEmailViewModel
	private let parentViewModel: EmailCheckViewModel
	
	// MARK: - Initialize
	init(
		viewModel: CertifyEmailViewModel,
		parentViewModel: EmailCheckViewModel
	) {
		self.viewModel = viewModel
		self.parentViewModel = parentViewModel
		
		super.init(frame: .zero)
		self.backgroundColor = GalapagosAsset.gray5Bg2.color
	}
	
	// MARK: - Methods
	
	override func setAddSubView() {
		super.setAddSubView()
		addSubviews([
			emailTextField,
			errorMessage,
			certifyEmailButton
		])
	}
	
	override func setConstraint() {
		super.setConstraint()
		
		emailTextField.snp.makeConstraints {
			$0.top.equalToSuperview()
			$0.leading.trailing.equalToSuperview()
			$0.height.equalTo(68)
		}
		
		errorMessage.snp.makeConstraints {
			$0.top.equalTo(emailTextField.snp.bottom).offset(6)
			$0.leading.equalToSuperview()
		}
		
		certifyEmailButton.snp.makeConstraints {
			$0.top.equalTo(emailTextField.snp.bottom).offset(12)
			$0.leading.trailing.equalToSuperview()
			$0.height.equalTo(52)
		}
		
	}
	
	override func setAttribute() {
		super.setAttribute()
	}
	
	override func bind() {
		super.bind()
		
		let input = CertifyEmailViewModel.Input(
			email: emailTextField.rx.text.orEmpty.asObservable(),
			sendCodeButtonTapped: certifyEmailButton.rx.tap.asObservable()
		)
		
		let output = viewModel.transform(input: input)
		
		output.receivedMessage
			.debug()
			.observe(on: MainScheduler.instance)
			.withUnretained(self)
			.subscribe(onNext: { owner, message in
				owner.certifyEmailButton.rxType.accept(.usage(.disabled))
				owner.emailTextField.rxType.accept(.disabled)
				owner.parentViewModel.certifyCodeIsHidden.accept(false)
				GalapagosToastManager.shared.addToast(message: "인증코드가 이메일로 전송되었습니다.")
			}, onError: { error in
				GalapagosToastManager.shared.addToast(message: error.localizedDescription )
			})
			.disposed(by: disposeBag)
		
		
		emailTextField.rxType
			.asObservable()
			.subscribe(onNext: { type in
				if type == .filed {
					self.certifyEmailButton.rxType.accept(.usage(.inactive))
				} else {
					self.certifyEmailButton.rxType.accept(.usage(.disabled))
				}
			})
			.disposed(by: disposeBag)
		
		emailTextField.rx.text.orEmpty
			.asDriver(onErrorJustReturn: "")
			.drive(onNext: { [weak self] email in
				guard let self = self else { return }
				self.parentViewModel.userEmail.accept(email)
			})
			.disposed(by: disposeBag)
		
	}
}
