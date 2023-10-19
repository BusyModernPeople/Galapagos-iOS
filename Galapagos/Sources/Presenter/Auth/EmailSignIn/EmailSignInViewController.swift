//
//  EmailSignInViewController.swift
//  Galapagos
//
//  Created by 조용인 on 2023/06/11.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//
import Foundation

import RxCocoa
import RxSwift

import SiriUIKit
import SnapKit

import UIKit


class EmailSignInViewController: BaseViewController {
	
	// MARK: - UI
	private lazy var navigationBar: GalapagosNavigationBarView = {
		let navigationBar = GalapagosNavigationBarView()
		navigationBar.setTitleText("")
		return navigationBar
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "이메일과 비밀번호를\n입력해주세요"
		label.numberOfLines = 2
		label.font = GalapagosFontFamily.Pretendard.bold.font(size: 28)
		label.textColor = GalapagosAsset.blackDisplayHeadingBody.color
		return label
	}()
	
	private lazy var emailTextField: GalapagosTextField = {
		let textField = GalapagosTextField(
			placeHolder: "이메일을 입력해주세요",
			maxCount: 0,
			clearMode: true
		)
		textField.isSecureTextEntry = false
		return textField
	}()
	
	private lazy var passwordTextField: GalapagosTextField = {
		let textField = GalapagosTextField(
			placeHolder: "비밀번호를 입력해주세요",
			maxCount: 0,
			clearMode: true
		)
		textField.isSecureTextEntry = true
		return textField
	}()
	
	private lazy var forgetPasswordLabel: UILabel = {
		let label = UILabel()
		label.text = "비밀번호를 잊으셨나요?"
		label.font = GalapagosFontFamily.Pretendard.regular.font(size: 14)
		label.textColor = GalapagosAsset.gray3DisableText1.color
		return label
	}()
	
	private lazy var resettingPasswordLabel: UILabel = {
		let label = UILabel()
		let text = "비밀번호 재설정"
		let attributedString = NSMutableAttributedString(string: text)
		
		let underLineAttributes: [NSAttributedString.Key: Any] = [
			.underlineStyle: NSUnderlineStyle.single.rawValue,
			.baselineOffset : NSNumber(value: 3)
		]
		attributedString.addAttributes(underLineAttributes, range: NSRange(location: 0, length: text.count))
		label.attributedText = attributedString
		label.font = GalapagosFontFamily.Pretendard.medium.font(size: 14)
		return label
	}()
	
	private lazy var resetPasswordStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [forgetPasswordLabel, resettingPasswordLabel])
		stackView.axis = .horizontal
		stackView.spacing = 4
		return stackView
	}()
	
	private lazy var signInButton: GalapagosButton = {
		let button = GalapagosButton(
			isRound: false,
			iconTitle: nil,
			type: .usage(.disabled),
			title: "로그인하기"
		)
		return button
	}()
	
	// MARK: - Properties
	private let viewModel: EmailSignInViewModel
	
	// MARK: - Initializers
	init(
		viewModel: EmailSignInViewModel
	) {
		self.viewModel = viewModel
		super.init()
	}
	
	// MARK: - LifeCycle
	
	// MARK: - Methods
	override func setAddSubView() {
		self.view.addSubviews([
			navigationBar,
			titleLabel,
			emailTextField,
			passwordTextField,
			resetPasswordStackView,
			signInButton
		])
	}
	
	override func setConstraint() {
		navigationBar.snp.makeConstraints{ make in
			make.top.equalTo(self.view.safeAreaLayoutGuide)
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(50)
		}
		
		titleLabel.snp.makeConstraints { make in
			make.top.equalTo(navigationBar.snp.bottom).galapagosOffset(offset: ._40)
			make.leading.equalToSuperview().offset(24)
		}
		
		emailTextField.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).galapagosOffset(offset: ._40)
			make.leading.equalToSuperview().offset(24)
			make.trailing.equalToSuperview().offset(-24)
			make.height.equalTo(68)
		}
		
		passwordTextField.snp.makeConstraints { make in
			make.top.equalTo(emailTextField.snp.bottom).galapagosOffset(offset: ._12)
			make.leading.equalToSuperview().offset(24)
			make.trailing.equalToSuperview().offset(-24)
			make.height.equalTo(68)
		}
		
		resetPasswordStackView.snp.makeConstraints{ make in
			make.top.equalTo(passwordTextField.snp.bottom).galapagosOffset(offset: ._32)
			make.centerX.equalToSuperview()
		}
		
		signInButton.snp.makeConstraints { make in
			make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).galapagosOffset(offset: ._16, reverse: true)
			make.leading.equalToSuperview().offset(24)
			make.trailing.equalToSuperview().offset(-24)
			make.height.equalTo(56)
		}
	}
	
	override func bind() {
		let input = EmailSignInViewModel.Input(
			email: emailTextField.rx.text.orEmpty.asObservable(),
			password: passwordTextField.rx.text.orEmpty.asObservable(),
			backBtnTapped: navigationBar.backButton.rx.tap.asObservable(),
			resettingPasswordBtnTapped: resettingPasswordLabel.rx.tapGesture().when(.recognized).map{_ in }.asObservable(),
			signInBtnTapped: signInButton.rx.tap.asObservable()
		)
		
		let output = viewModel.transform(input: input)
		
		output.signInBtnEnable
			.withUnretained(self)
			.subscribe(onNext: { owner, enable in
				enable == true
				? owner.signInButton.rxType.accept(.usage(.inactive))
				: owner.signInButton.rxType.accept(.usage(.disabled))
			})
			.disposed(by: disposeBag)
		
	}
	
}


// MARK: - Extension
extension EmailSignInViewController {
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
}
