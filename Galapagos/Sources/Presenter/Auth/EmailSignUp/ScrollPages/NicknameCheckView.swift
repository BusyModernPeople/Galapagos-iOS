//
//  NicknameCheckView.swift
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

final class NicknameCheckView: UIView {
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임을\n입력해주세요"
        label.numberOfLines = 2
        label.font = GalapagosFontFamily.Pretendard.bold.font(size: 28)
        label.textColor = GalapagosAsset.black제목DisplayHeadingBody.color
        return label
    }()
    
    private lazy var nickNameTextField: GalapagosTextField = {
        let textField = GalapagosTextField(
            placeHolder: "2-6자리로 입력해주세요",
            maxCount: 6,
            errorMessage: "잘못된 닉네임 입니다."
        )
        return textField
    }()
    
    private lazy var nicknameErrorCell: TextFieldErrorCell = {
        let cell = TextFieldErrorCell(errorMessage: "너무 재미있고 독특한 이름이네요!")
        cell.changeState(state: .success)
        cell.isHidden = true
        return cell
    }()
    
    
    
    
    // MARK: - Properties
    
    private let viewModel: EmailSignUpViewModel
    private let disposeBag = DisposeBag()
    
    private let nicknameCertificate = BehaviorRelay<Bool>(value: false)
    
    
    
    
    
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
    
    private func addViews() {
        addSubviews([
            titleLabel,
            nickNameTextField,
            nicknameErrorCell
        ])
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
        }
        
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(68)
        }
        
        nicknameErrorCell.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(20)
        }
        
    }
    
    private func bind() {
        
        // TODO: 입력을 마치고 나서 확인을 누르면, 서버에서 닉네임 중복 확인. (usecase)
        nickNameTextField.rx.controlEvent(.editingDidEnd)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                guard let text = owner.nickNameTextField.text else { return }
                owner.checkPasswordLengthValidation(password: text)
            })
            .disposed(by: disposeBag)
        
        nickNameTextField.rx.controlEvent(.editingDidBegin)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.checkPasswordLengthValidation(password: "")
            })
            .disposed(by: disposeBag)
        
        nicknameCertificate
            .asDriver(onErrorJustReturn: false)
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isValidated in
                guard let self = self else { return }
                self.viewModel.readyForNextButton.accept(isValidated)
                self.nicknameErrorCell.isHidden = !isValidated
            })
            .disposed(by: disposeBag)
        
    }
    
    //닉네임이 2자~6자인지 확인해서 Observable<Bool>타입으로 반환해주는 함수
    private func checkPasswordLengthValidation(password: String) {
        Observable.just(password.count >= 2 && password.count <= 6)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isValidated in
                guard let self = self else { return }
                self.nicknameCertificate.accept(isValidated)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Extension
extension NicknameCheckView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
