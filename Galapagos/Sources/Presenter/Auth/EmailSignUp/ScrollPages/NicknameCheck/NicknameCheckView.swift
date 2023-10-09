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
            maxCount: 6
        )
        return textField
    }()
    
    private lazy var nicknameErrorCell: GalapagosErrorMessage = {
        let errorMessage = GalapagosErrorMessage(title: "", type: .None)
        return errorMessage
    }()
    
    private lazy var completeSignUpButton: GalapagosButton = {
        let button = GalapagosButton(
            isRound: false,
            iconTitle: nil,
            type: .Usage(.Disabled),
            title: "가입 완료"
        )
        return button
    }()
    
    // MARK: - Properties
    private let parentViewModel: EmailSignUpViewModel
    private let viewModel: NicknameCheckViewModel
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Initializers
    
    public init(
        parentViewModel: EmailSignUpViewModel,
        viewModel: NicknameCheckViewModel
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
        
        completeSignUpButton.snp.makeConstraints{ nextButton in
            nextButton.centerX.equalToSuperview()
            nextButton.width.equalToSuperview().multipliedBy(0.9)
            nextButton.bottom.equalToSuperview().inset(50)
            nextButton.height.equalTo(56)
        }
        
    }
    
    private func bind() {
        let input = NicknameCheckViewModel.Input(
            nickname: nickNameTextField.rx.text.orEmpty.asObservable(),
            completeBtnTapped: completeSignUpButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.certifyNickname
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                owner.parentViewModel.readyForNextButton.accept(result)
                if result {
                    owner.nicknameErrorCell.rxType.accept(.Success)
                    owner.nicknameErrorCell.setErrorMessage(message: "재미있고 독특한 이름이네요!")
                } else {
                    owner.nicknameErrorCell.rxType.accept(.Info)
                    owner.nicknameErrorCell.setErrorMessage(message: "2-6자리로 입력해주세요")
                }
            })
            .disposed(by: disposeBag)
        
        output.letsSignUp
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.parentViewModel.letsGoSignUp.accept(true)
            })
            .disposed(by: disposeBag)
        
        
        nickNameTextField.rx.text.orEmpty
            .asDriver()
            .drive(onNext: { [weak self] nickname in
                guard let self = self else { return }
                self.parentViewModel.nickname.accept(nickname)
                self.parentViewModel.socialType.accept("EMAIL")
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
