//
//  EmailCheckView.swift
//  Galapagos
//
//  Created by 조용인 on 2023/06/23.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit
import SiriUIKit

import SnapKit

import RxSwift
import RxCocoa
import RxGesture

final class EmailCheckView: UIView {
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일을\n입력해주세요"
        label.numberOfLines = 2
        label.font = GalapagosFontFamily.Pretendard.bold.font(size: 28)
        label.textColor = GalapagosAsset.black제목DisplayHeadingBody.color
        return label
    }()
    
    private lazy var certifyEmailView: CertifyEmailView = {
        let view = CertifyEmailView(
            viewModel: CertifyEmailViewModel(
                usecase: DefaultCertifyCodeWithEmailUsecase(
                    authRepository: DefaultEmailRepository()
                )
            ),
            parentViewModel: viewModel
        )
        return view
    }()
    
    private lazy var certifyCodeView: CertifyCodeView = {
        let view = CertifyCodeView(
            viewModel: CertifyCodeViewModel(
                usecase: DefaultCertifyCodeWithEmailUsecase(
                    authRepository: DefaultEmailRepository()
                )
            ),
            parentViewModel: viewModel
        )
        return view
    }()
    
    // MARK: - Properties
    private var disposeBag = DisposeBag()
    private var parentViewModel: EmailSignUpViewModel
    private var viewModel: EmailCheckViewModel
    
    /// 이메일 인증 API의 return을 담아낸다 (초기값 false)
    private let emailCertified: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    
    // MARK: - Initializers
    init(
        parentViewModel: EmailSignUpViewModel,
        viewModel: EmailCheckViewModel
    ) {
        self.parentViewModel = parentViewModel
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setAddSubView()
        setConstraint()
        bind()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    // MARK: - Methods
    
    private func setAddSubView() {
        self.addSubviews([
            titleLabel,
            certifyEmailView,
            certifyCodeView
        ])
    }
    
    private func setConstraint() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self)
            $0.leading.equalTo(self).offset(24)
        }
        
        certifyEmailView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(148)
        }
        
        certifyCodeView.snp.makeConstraints {
            $0.top.equalTo(certifyEmailView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(148)
        }
    }
    
    private func bind() {
        
        let input = EmailCheckViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.certifyCodeIsHidden
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, isHidden in
                owner.certifyCodeView.isHidden = isHidden
                if !isHidden {
                    owner.certifyCodeView.timerTextField.rx.becomeFirstResponder.onNext(())
                }
            })
            .disposed(by: disposeBag)
        
        output.nextButtonIsAvailable
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, isAvailable in
                owner.parentViewModel.readyForNextButton.accept(isAvailable)
            })
            .disposed(by: disposeBag)
        
        certifyCodeView.timerTextField.rx.controlEvent([.editingDidBegin])
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                UIView.animate(withDuration: 0.5) {
                    owner.frame.origin.y -= (owner.titleLabel.frame.height + 40)
                    owner.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        
        
        certifyCodeView.timerTextField.rx.controlEvent([.editingDidEnd])
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                UIView.animate(withDuration: 0.5) {
                    owner.frame.origin.y += (owner.titleLabel.frame.height + 40)
                    owner.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        
        certifyEmailView.emailTextField.rx.text.orEmpty
            .asDriver()
            .drive(onNext: { [weak self] email in
                guard let self = self else { return }
                self.parentViewModel.email.accept(email)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Extension
extension EmailCheckView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
