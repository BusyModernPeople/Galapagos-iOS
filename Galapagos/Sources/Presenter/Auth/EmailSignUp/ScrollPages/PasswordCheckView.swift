//
//  PasswordCheckView.swift
//  Galapagos
//
//  Created by 조용인 on 2023/06/23.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit
import SiriUIKit

import RxSwift
import RxCocoa

import SnapKit

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
            maxCount: 20,
            errorMessage: "잘못된 비밀번호 입니다."
        )
        textFieldView.isSecureTextEntry = true
        return textFieldView
    }()
    
    private lazy var passwordCheckTextField: GalapagosTextField = {
        let textFieldView = GalapagosTextField(
            placeHolder: "비밀번호를 재입력해주세요",
            maxCount: 20,
            errorMessage: "잘못된 비밀번호 입니다."
        )
        /// 비밀번호 확인은 우선 터치 막아두자
        textFieldView.isUserInteractionEnabled = false
        textFieldView.isSecureTextEntry = true
        return textFieldView
    }()
    
    private lazy var passwordErrorStackView: UIStackView = {
        let errorCell: [TextFieldErrorCell] = [
            TextFieldErrorCell(errorMessage: "영문포함"),
            TextFieldErrorCell(errorMessage: "숫자포함"),
            TextFieldErrorCell(errorMessage: "특수문자포함"),
            TextFieldErrorCell(errorMessage: "8자~20자"),
        ]
        let stackView = UIStackView(arrangedSubviews: errorCell)
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var passwordCheckErrorCell: TextFieldErrorCell = {
        let errorCell = TextFieldErrorCell(errorMessage: "비밀번호 일치")
        return errorCell
    }()
    
    
    
    // MARK: - Properties
    
    private let viewModel: EmailSignUpViewModel
    private let disposeBag = DisposeBag()
    
    private let engValied: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    private let numValied: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    private let speValied: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    private let couValied: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    private let passwordResultCombined: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    private let checkPasswordValied: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    // MARK: - Initializers
    
    init(
        frame: CGRect,
        viewModel: EmailSignUpViewModel
    ) {
        self.viewModel = viewModel
        super.init(frame: frame)
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
            passwordErrorStackView,
            passwordCheckTextField,
            passwordCheckErrorCell
        ])
    }
    
    private func setConstraints(){
        titleLabel.snp.makeConstraints { titleLabel in
            titleLabel.top.equalToSuperview().offset(24)
            titleLabel.leading.equalToSuperview().offset(24)
        }
        
        passwordTextField.snp.makeConstraints { passwordTextField in
            passwordTextField.top.equalTo(titleLabel.snp.bottom).offset(40)
            passwordTextField.leading.equalToSuperview().offset(24)
            passwordTextField.trailing.equalToSuperview().offset(-24)
            passwordTextField.height.equalTo(68)
        }
        
        passwordErrorStackView.snp.makeConstraints { passwordErrorStackView in
            passwordErrorStackView.top.equalTo(passwordTextField.snp.bottom).offset(6)
            passwordErrorStackView.leading.equalToSuperview().offset(24)
        }
        
        passwordCheckTextField.snp.makeConstraints { passwordCheckTextField in
            passwordCheckTextField.top.equalTo(passwordErrorStackView.snp.bottom).offset(30)
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
        passwordTextField.rx.text.orEmpty
            .asDriver()
            .distinctUntilChanged()
            .drive(onNext: { [weak self] text in
                guard let self = self else { return }
                self.checkPasswordEnglishValidation(password: text)
                self.checkPasswordNumberValidation(password: text)
                self.checkPasswordSpecialCharacterValidation(password: text)
                self.checkPasswordLengthValidation(password: text)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(engValied, numValied, speValied, couValied)
            .map { $0 && $1 && $2 && $3 }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isValidated in
                guard let self = self else { return }
                self.passwordResultCombined.onNext(isValidated)
            })
            .disposed(by: disposeBag)
        
        passwordResultCombined
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isValidated in
                guard let self = self else { return }
                self.passwordCheckTextField.isUserInteractionEnabled = isValidated
            })
            .disposed(by: disposeBag)
        
        passwordCheckTextField.rx.text.orEmpty
            .asDriver()
            .drive(onNext: { [weak self] text in
                guard let self = self else { return }
                text == passwordTextField.text! && !text.isEmpty ? self.checkPasswordValied.onNext(true) : self.checkPasswordValied.onNext(false)
            })
            .disposed(by: disposeBag)
        
        checkPasswordValied
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isValidated in
                guard let self = self else { return }
                isValidated ? self.passwordCheckErrorCell.changeState(state: .success) : self.passwordCheckErrorCell.changeState(state: .error)
                self.viewModel.readyForNextButton.accept(isValidated)
            })
            .disposed(by: disposeBag)
        
    }
    
    //영어가 들어있는지를 확인해서 Observable<Bool>타입으로 반환해주는 함수
    private func checkPasswordEnglishValidation(password: String) {
        let passwordRegex = ".*[A-Za-z]+.*"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        Observable.just(passwordTest.evaluate(with: password))
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isValidated in
                guard let self = self else { return }
                guard let cell = passwordErrorStackView.subviews[0] as? TextFieldErrorCell else { return }
                isValidated ? cell.changeState(state: .success) : cell.changeState(state: .error)
                self.engValied.onNext(isValidated)
            })
            .disposed(by: disposeBag)
    }
    
    //숫자가 들어있는지를 확인해서 Observable<Bool>타입으로 반환해주는 함수
    private func checkPasswordNumberValidation(password: String) {
        let passwordRegex = ".*[0-9]+.*"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        Observable.just(passwordTest.evaluate(with: password))
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isValidated in
                guard let self = self else { return }
                guard let cell = passwordErrorStackView.subviews[1] as? TextFieldErrorCell else { return }
                isValidated ? cell.changeState(state: .success) : cell.changeState(state: .error)
                self.numValied.onNext(isValidated)
            })
            .disposed(by: disposeBag)
    }
    
    //특수문자가 들어있는지를 확인해서 Observable<Bool>타입으로 반환해주는 함수
    private func checkPasswordSpecialCharacterValidation(password: String) {
        let passwordRegex = ".*[!@#$%^&*()_+{}:<>?]+.*"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        Observable.just(passwordTest.evaluate(with: password))
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isValidated in
                guard let self = self else { return }
                guard let cell = passwordErrorStackView.subviews[2] as? TextFieldErrorCell else { return }
                isValidated ? cell.changeState(state: .success) : cell.changeState(state: .error)
                self.speValied.onNext(isValidated)
                
            })
            .disposed(by: disposeBag)
    }
    
    //비밀번호가 8자~20자인지 확인해서 Observable<Bool>타입으로 반환해주는 함수
    private func checkPasswordLengthValidation(password: String) {
        Observable.just(password.count >= 8 && password.count <= 20)
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isValidated in
                guard let self = self else { return }
                guard let cell = passwordErrorStackView.subviews[3] as? TextFieldErrorCell else { return }
                isValidated ? cell.changeState(state: .success) : cell.changeState(state: .error)
                self.couValied.onNext(isValidated)
                
            })
            .disposed(by: disposeBag)
    }
    
    
    // TODO: 각 Error의 state를 combineLatest해서 isValied면 checkPassword Active하게
    private func checkPasswordValidation() {
        
    }
    
}

// MARK: - Extension
extension PasswordCheckView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
