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
                    authRepository: DefaultAuthRepository()
                )
            ),
            parentViewModel: viewModel
        )
        return view
    }()
    
    private lazy var certifyCodeView: CertifyCodeView = {
        let view = CertifyCodeView()
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
            $0.height.equalTo(132)
        }
        
        certifyCodeView.snp.makeConstraints {
            $0.top.equalTo(certifyEmailView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(132)
        }
    }
    
    private func bind() {
        
        viewModel.certifyCodeIsHidden
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, isHidden in
                owner.certifyCodeView.isHidden = isHidden
                if !isHidden {
                    owner.certifyCodeView.timerTextField.rx.becomeFirstResponder.onNext(())
                }
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
//
//        emailTextField.isEnable
//            .asDriver(onErrorJustReturn: false)
//            .drive(certifyEmailButton.rx.isActive)
//            .disposed(by: disposeBag)
//        
//        certifyEmailButton.rx.tap
//            .subscribe(onNext: { [weak self] in
//                guard let self = self else { return }
//                // TODO: 이메엘 인증 API호출 (Usecase통해서)
//                // 인증 성공 결과를 Observable<Bool>로 전달 해줘야함
//                
//                /// 임시 fake
//                self.emailCertified.accept(true)
//                self.emailTextField.isEnable.accept(false)
//                self.emailTextField.isUserInteractionEnabled = false
//            })
//            .disposed(by: disposeBag)
//        
        // TODO: 이메일 인증받은 결과를 subscribe 해줘야함
        // 그리고, 결과에 따라서 인증코드 확인하는 View 보여줘야함
//        emailCertified
//            .distinctUntilChanged() // 기본값이 false라서, 인증이 될 때만 통과함
//            .subscribe(onNext: { [weak self] isCertified in
//                guard let self = self else { return }
//                if isCertified{
//                    // TODO: 인증된 상태라면 isHidden풀어주고, timer on
//                    self.checkCertifiCodeView.isHidden = false
//                    self.checkCertifiCodeView.isTimerStarted.accept(true)
//                }else{
//                    self.checkCertifiCodeView.isTimerStarted.accept(false)
//                }
//            })
//            .disposed(by: disposeBag)
//        
        // TODO: 확인버튼 눌렀을 때, API호출 해야함. 그리고 결과를 Observable<Bool>로 반환
//        
//        checkCertifiCodeView.isButtonTapped
//            .asDriver(onErrorJustReturn: false)
//            .drive(onNext: { [weak self] isTapped in
//                guard let self = self else { return }
//                // TODO: 인증코드 확인하는 API호출 해야함 (Usecase에서)
//                // 코드의 인증 결과를 Bool타입으로 전달해줘야함
//                
//                // Fake
//                self.viewModel.readyForNextButton.accept(true)
//            })
//            .disposed(by: disposeBag)
//        
        // TODO: 만약, 인증코드가 잘 되어있으면 -> isButtonTapped에 true전달, checkButton 비활성화, 해당 뷰 isUserInteractionEnabled 꺼주기 | 인증코드가 잘 안되어 있으면 -> 반댓값
    }
}

// MARK: - Extension
extension EmailCheckView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
