//
//  PasswordCheckView.swift
//  Galapagos
//
//  Created by 조용인 on 2023/06/23.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//
import RxCocoa
import RxSwift

import SiriUIKit
import SnapKit

import UIKit

final class PasswordCheckView: UIView {
	// MARK: - UI
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "비밀번호를\n입력해주세요"
		label.numberOfLines = 2
		label.font = GalapagosFontFamily.Pretendard.bold.font(size: 28)
		label.textColor = GalapagosAsset.black제목DisplayHeadingBody.color
		return label
	}()
	
	private lazy var passwordTextField: GalapagosTextField = {
		let textFieldView = GalapagosTextField(
			placeHolder: "비밀번호를 입력해주세요",
			maxCount: 20
		)
		textFieldView.isSecureTextEntry = true
		return textFieldView
	}()
	
	private lazy var passwordCheckTextField: GalapagosTextField = {
		let textFieldView = GalapagosTextField(
			placeHolder: "비밀번호를 재입력해주세요",
			maxCount: 20
		)
		textFieldView.isSecureTextEntry = true
		return textFieldView
	}()
	
	private lazy var passwordErrorCells: [GalapagosErrorMessage] = {
		let errorCell: [GalapagosErrorMessage] = [
			GalapagosErrorMessage(title: "영문포함", type: .disabled),
			GalapagosErrorMessage(title: "숫자포함", type: .disabled),
			GalapagosErrorMessage(title: "특수문자포함", type: .disabled),
			GalapagosErrorMessage(title: "8자~20자", type: .disabled)
		]
		return errorCell
	}()
	
	private lazy var passwordErrorStackView: [UIStackView] = {
		let stackViewFirst = UIStackView(
			arrangedSubviews:
				[	passwordErrorCells[0],
					passwordErrorCells[1],
					passwordErrorCells[2] ]
		)
		let stackViewSecond = UIStackView(arrangedSubviews: [passwordErrorCells[3]])
		stackViewFirst.axis = .horizontal
		stackViewFirst.spacing = 8
		stackViewSecond.axis = .horizontal
		stackViewSecond.spacing = 8
		return [stackViewFirst, stackViewSecond]
	}()
	
	private lazy var passwordErrorVertical: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: passwordErrorStackView)
		stackView.axis = .vertical
		stackView.spacing = 4
		return stackView
	}()
	
	private lazy var passwordCheckErrorCell: GalapagosErrorMessage = {
		let errorCell = GalapagosErrorMessage(title: "비밀번호 일치", type: .disabled)
		return errorCell
	}()
	
	// MARK: - Properties
	
	private let parentViewModel: EmailSignUpViewModel
	private let viewModel: PasswordCheckViewModel
	private let disposeBag = DisposeBag()
	
	// MARK: - Initializers
	
	init(
		parentViewModel: EmailSignUpViewModel,
		viewModel: PasswordCheckViewModel
	) {
		self.parentViewModel = parentViewModel
		self.viewModel = viewModel
		super.init(frame: .zero)
		addViews()
		setConstraints()
		bind()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Methods
	
	private func addViews(){
		self.addSubviews([
			titleLabel,
			passwordTextField,
			passwordErrorVertical,
			passwordCheckTextField,
			passwordCheckErrorCell
		])
	}
	
	private func setConstraints(){
		titleLabel.snp.makeConstraints { titleLabel in
			titleLabel.top.equalTo(self)
			titleLabel.leading.equalTo(self).offset(24)
		}
		
		passwordTextField.snp.makeConstraints { passwordTextField in
			passwordTextField.top.equalTo(titleLabel.snp.bottom).offset(40)
			passwordTextField.leading.equalToSuperview().offset(24)
			passwordTextField.trailing.equalToSuperview().offset(-24)
			passwordTextField.height.equalTo(68)
		}
		
		passwordErrorVertical.snp.makeConstraints { passwordErrorVertical in
			passwordErrorVertical.top.equalTo(passwordTextField.snp.bottom).offset(6)
			passwordErrorVertical.leading.equalTo(passwordTextField)
		}
		
		passwordCheckTextField.snp.makeConstraints { passwordCheckTextField in
			passwordCheckTextField.top.equalTo(passwordErrorVertical.snp.bottom).offset(30)
			passwordCheckTextField.leading.equalToSuperview().offset(24)
			passwordCheckTextField.trailing.equalToSuperview().offset(-24)
			passwordCheckTextField.height.equalTo(68)
		}
		
		passwordCheckErrorCell.snp.makeConstraints { passwordCheckErrorCell in
			passwordCheckErrorCell.top.equalTo(passwordCheckTextField.snp.bottom).offset(6)
			passwordCheckErrorCell.leading.equalToSuperview().offset(24)
		}
		
	}
	
	// TODO: 원래는 Usecase에 들어가야할 애들인데, 일단은 여기에 다 박아둠
	
	private func bind(){
		
		let input = PasswordCheckViewModel.Input(
			password: passwordTextField.rx.text.orEmpty.asObservable(),
			rePassword: passwordCheckTextField.rx.text.orEmpty.asObservable()
		)
		
		let output = viewModel.transform(input: input)
		
		
		output.passwordValidations.enumerated()
			.map { idx, observable in
				observable
					.withUnretained(self)
					.subscribe(onNext: { owner, active in
						let type: GalapagosErrorMessage.GalapagosErrorMessageType = active ? .success : .disabled
						owner.passwordErrorCells[idx].rxType.accept(type)
					})
			}
			.forEach { $0.disposed(by: disposeBag) }
		
		output.firstPasswordCorrect
			.withUnretained(self)
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { owner, isValidated in
				if isValidated {
					owner.passwordCheckTextField.rxType.accept(.def)
				} else {
					owner.passwordCheckTextField.text = ""
					owner.passwordCheckTextField.rxType.accept(.disabled)
				}
			})
			.disposed(by: disposeBag)
		
		output.correspondRegex
			.withUnretained(self)
			.subscribe(onNext: { owner, isValidated in
				let type: GalapagosErrorMessage.GalapagosErrorMessageType = isValidated ? .success : .disabled
				owner.passwordCheckErrorCell.rxType.accept(type)
			})
			.disposed(by: disposeBag)
		
		output.nextAvailable
			.withUnretained(self)
			.subscribe(onNext: { owner, moveNext in
				owner.parentViewModel.readyForNextButton.accept(moveNext)
			})
			.disposed(by: disposeBag)
		
		
		passwordTextField.rx.controlEvent([.editingDidBegin])
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				UIView.animate(withDuration: 0.5) {
					owner.frame.origin.y -= (owner.titleLabel.frame.height + 40)
					owner.layoutIfNeeded()
				}
			})
			.disposed(by: disposeBag)
		
		passwordTextField.rx.controlEvent([.editingDidEnd])
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				UIView.animate(withDuration: 0.5) {
					owner.frame.origin.y += (owner.titleLabel.frame.height + 40)
					owner.layoutIfNeeded()
				}
			})
			.disposed(by: disposeBag)
		
		passwordCheckTextField.rx.controlEvent([.editingDidBegin])
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				UIView.animate(withDuration: 0.5) {
					owner.frame.origin.y -= (owner.titleLabel.frame.height + 40)
					owner.frame.origin.y -= (owner.passwordTextField.frame.height + 6)
					owner.frame.origin.y -= 40
					owner.layoutIfNeeded()
				}
			})
			.disposed(by: disposeBag)
		
		passwordCheckTextField.rx.controlEvent([.editingDidEnd])
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				UIView.animate(withDuration: 0.5) {
					owner.frame.origin.y += (owner.titleLabel.frame.height + 40)
					owner.frame.origin.y += (owner.passwordTextField.frame.height + 6)
					owner.frame.origin.y += 40
					owner.layoutIfNeeded()
				}
			})
			.disposed(by: disposeBag)
		
		passwordCheckTextField.rx.text.orEmpty
			.asDriver()
			.drive(onNext: { [weak self] password in
				guard let self = self else { return }
				self.parentViewModel.password.accept(password)
			})
			.disposed(by: disposeBag)
	}
}

// MARK: - Extension
extension PasswordCheckView {
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.endEditing(true)
	}
}
