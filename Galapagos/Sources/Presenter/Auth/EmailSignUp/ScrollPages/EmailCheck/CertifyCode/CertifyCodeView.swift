//
//  CertifyCodeView.swift
//  Galapagos
//
//  Created by Siri on 2023/10/02.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation
import UIKit
import SiriUIKit

import RxSwift
import RxCocoa

final class CertifyCodeView: BaseView {
    
    // MARK: - UI Components
    public lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일로 전송된 인증번호를 입력해주세요"
        label.font = SiriUIKitFontFamily.Pretendard.medium.font(size: 14)
        return label
    }()
    
    public lazy var timerTextField: GalapagosTextField_Timer = {
        let textField = GalapagosTextField_Timer(
            placeHolder: "인증코드 6자리 입력",
            maxCount: 6,
            errorMessage: ""
        )
        return textField
    }()
    
    public lazy var reSendEmail: UIButton = {
        let button = UIButton()
        button.setTitle("인증코드 재전송", for: .normal)
        button.titleLabel?.font = SiriUIKitFontFamily.Pretendard.medium.font(size: 14)
        button.setTitleColor(GalapagosAsset.black제목DisplayHeadingBody.color, for: .normal)
        return button
    }()
    
    
    
    // MARK: - Properties
    
    private let viewModel: CertifyCodeViewModel
    private let parentViewModel: EmailCheckViewModel
    
    // MARK: - Initialize
    init(viewModel: CertifyCodeViewModel,
         parentViewModel: EmailCheckViewModel) {
        self.viewModel = viewModel
        self.parentViewModel = parentViewModel
        
        super.init(frame: .zero)
    }
    
    override func setAddSubView() {
        super.setAddSubView()
        addSubviews([
            infoLabel,
            timerTextField,
            reSendEmail
        ])
    
    }
    
    override func setConstraint() {
        super.setConstraint()
        
        infoLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        timerTextField.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).GalapagosOffset(offset: ._12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(68)
        }
    
        reSendEmail.snp.makeConstraints {
            $0.trailing.equalTo(timerTextField.snp.trailing)
            $0.top.equalTo(timerTextField.snp.bottom).offset(6)
        }
        
    }
    
    override func setAttribute() {
        super.setAttribute()
    }
    
    override func bind() {
        super.bind()
        
        let input = CertifyCodeViewModel.Input(certifyCode: timerTextField.rx.text.orEmpty.asObservable(),
                                               email: parentViewModel.userEmail.asObservable(),
                                               sendCertifyCodeTapped: timerTextField.rx.confirmBtnTapped.asObservable(),
                                               reSendEmailTapped: reSendEmail.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        
        
        reSendEmail.rx.tap
            .bind(to: timerTextField.resetTimerSubject)
            .disposed(by: disposeBag)
        
        output.resultOfCertify
            .skip(1)
            .withUnretained(self)
            .subscribe(onNext: { owner, isAvailable in
                owner.parentViewModel.nextButtonIsAvailable.accept(isAvailable)
                if isAvailable {
                    owner.timerTextField.rxType.accept(.disabled)
                } else {
                    owner.timerTextField.rxType.accept(.error)
                }
            })
            .disposed(by: disposeBag)
        
        output.receivedMessage
            .subscribe(onNext: { message in
                print("✨ 인증결과는?: \(message) ✨")
            })
            .disposed(by: disposeBag)
        
        
        output.resendEmailMessage
            .subscribe(onNext: { message in
                print("✨ 다시 보내기 결과는?: \(message) ✨")
            })
            .disposed(by: disposeBag)
    }
    // MARK: - Methods
}
