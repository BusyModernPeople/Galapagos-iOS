//
//  TermsAndConditionsView.swift
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

final class TermsAndConditionsView: UIView {
    // MARK: - UI
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "약관동의"
        label.font = GalapagosFontFamily.Pretendard.bold.font(size: 28)
        label.textColor = GalapagosAsset.black제목DisplayHeadingBody.color
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "서비스 이용 약관에 동의해주세요"
        label.font = GalapagosFontFamily.Pretendard.regular.font(size: 16)
        label.textColor = GalapagosAsset.gray2주석CaptionSmall힌트PlaceholderText.color
        return label
    }()
    
    private lazy var allAgreeView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = false
        view.cornerRadius = 12
        return view
    }()
    
    private lazy var allAgreeShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = GalapagosAsset.black제목DisplayHeadingBody.color.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var allAgreeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.addArrangedSubview(allAgreeButton)
        stackView.addArrangedSubview(allAgreeLabel)
        return stackView
    }()
    
    private lazy var allAgreeButton: UIButton = {
        let button = UIButton()
        button.setImage(GalapagosAsset._24x24checkRoundDefault.image, for: .normal)
        button.setImage(GalapagosAsset._24x24checkRoundActive.image, for: .selected)
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    private lazy var allAgreeLabel: UILabel = {
        let label = UILabel()
        label.text = "전체 동의하기"
        label.font = GalapagosFontFamily.Pretendard.semiBold.font(size: 18)
        label.textColor = GalapagosAsset.black제목DisplayHeadingBody.color
        return label
    }()
    
    private lazy var termsAgreeButton: UIButton = {
        let button = UIButton()
        button.setImage(GalapagosAsset._24x24checkRoundDefault.image, for: .normal)
        button.setImage(GalapagosAsset._24x24checkRoundActive.image, for: .selected)
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    private lazy var termsAgreeLabel: UILabel = {
        let label = UILabel()
        let text = "이용약관(필수)"
        let attributedString = NSMutableAttributedString(string: text)
        
        let blackAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: GalapagosAsset.black제목DisplayHeadingBody.color
        ]
        let greenAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: GalapagosAsset.green.color
        ]
        let hiperLinkAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .baselineOffset : NSNumber(value: 3)
        ]
        let galapagosRange = (text as NSString).range(of: "(필수)")
        attributedString.addAttributes(blackAttributes, range: NSRange(location: 0, length: text.count))
        attributedString.addAttributes(greenAttributes, range: galapagosRange)
        attributedString.addAttributes(hiperLinkAttributes, range: NSRange(location: 0, length: text.count))
        label.attributedText = attributedString
        label.font = GalapagosFontFamily.Pretendard.regular.font(size: 16)
        return label
    }()
    
    private lazy var privacyAgreeButton: UIButton = {
        let button = UIButton()
        button.setImage(GalapagosAsset._24x24checkRoundDefault.image, for: .normal)
        button.setImage(GalapagosAsset._24x24checkRoundActive.image, for: .selected)
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    private lazy var privacyAgreeLabel: UILabel = {
        let label = UILabel()
        let text = "개인정보 취급방침(필수)"
        let attributedString = NSMutableAttributedString(string: text)
        let blackAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: GalapagosAsset.black제목DisplayHeadingBody.color
        ]
        let greenAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: GalapagosAsset.green.color
        ]
        let hiperLinkAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .baselineOffset : NSNumber(value: 3)
        ]
        let galapagosRange = (text as NSString).range(of: "(필수)")
        attributedString.addAttributes(blackAttributes, range: NSRange(location: 0, length: text.count))
        attributedString.addAttributes(greenAttributes, range: galapagosRange)
        attributedString.addAttributes(hiperLinkAttributes, range: NSRange(location: 0, length: text.count))
        label.attributedText = attributedString
        label.font = GalapagosFontFamily.Pretendard.regular.font(size: 16)
        return label
    }()
    
    private lazy var eventAgreeButton: UIButton = {
        let button = UIButton()
        button.setImage(GalapagosAsset._24x24checkRoundDefault.image, for: .normal)
        button.setImage(GalapagosAsset._24x24checkRoundActive.image, for: .selected)
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    private lazy var eventAgreeLabel: UILabel = {
        let label = UILabel()
        let text = "이벤트 및 마케팅 정보 이메일 수신 동의(선택)"
        let attributedString = NSMutableAttributedString(string: text)
        let blackAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: GalapagosAsset.black제목DisplayHeadingBody.color
        ]
        let greenAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: GalapagosAsset.gray3DisableText1.color
        ]
        let galapagosRange = (text as NSString).range(of: "(선택)")
        attributedString.addAttributes(blackAttributes, range: NSRange(location: 0, length: text.count))
        attributedString.addAttributes(greenAttributes, range: galapagosRange)
        label.attributedText = attributedString
        label.font = GalapagosFontFamily.Pretendard.regular.font(size: 16)
        return label
    }()
    
    // MARK: - Properties
    private var disposeBag = DisposeBag()
    private var parentViewModel: EmailSignUpViewModel
    private var viewModel: TermsAndConditionsViewModel
    
    // MARK: - Initializers
    init(
        parentViewModel: EmailSignUpViewModel,
        viewModel: TermsAndConditionsViewModel
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
            titleStackView,
            allAgreeShadowView,
            allAgreeView,
            allAgreeStackView,
            termsAgreeButton,
            termsAgreeLabel,
            privacyAgreeButton,
            privacyAgreeLabel,
            eventAgreeButton,
            eventAgreeLabel
        ])
    }
    
    private func setConstraint() {
        
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        allAgreeView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(70)
        }
        
        allAgreeShadowView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(allAgreeView)
        }
        
        allAgreeStackView.snp.makeConstraints {
            $0.centerY.equalTo(allAgreeView)
            $0.leading.equalTo(allAgreeView).offset(20)
        }
        
        termsAgreeButton.snp.makeConstraints {
            $0.top.equalTo(allAgreeView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(24)
            $0.width.height.equalTo(24)
        }
        
        termsAgreeLabel.snp.makeConstraints {
            $0.bottom.equalTo(termsAgreeButton).offset(2)
            $0.leading.equalTo(termsAgreeButton.snp.trailing).offset(10)
        }
        
        privacyAgreeButton.snp.makeConstraints {
            $0.top.equalTo(termsAgreeButton.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.width.height.equalTo(24)
        }
        
        privacyAgreeLabel.snp.makeConstraints {
            $0.bottom.equalTo(privacyAgreeButton).offset(2)
            $0.leading.equalTo(privacyAgreeButton.snp.trailing).offset(10)
        }
        
        eventAgreeButton.snp.makeConstraints {
            $0.top.equalTo(privacyAgreeButton.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.width.height.equalTo(24)
        }
        
        eventAgreeLabel.snp.makeConstraints {
            $0.centerY.equalTo(eventAgreeButton)
            $0.leading.equalTo(eventAgreeButton.snp.trailing).offset(10)
        }
        
    }
    
    private func bind() {
        
        let input = TermsAndConditionsViewModel.Input(
            allAgreeBtnTapped: allAgreeButton.rx.tap.asObservable(),
            termsBtnTapped: termsAgreeButton.rx.tap.asObservable(),
            conditionBtnTapped: privacyAgreeButton.rx.tap.asObservable(),
            eventBtnTapped: eventAgreeButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.allAgreeBtnState
            .bind(to: allAgreeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.termsBtnState
            .bind(to: termsAgreeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.conditionBtnState
            .bind(to: privacyAgreeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.eventBtnState
            .bind(to: eventAgreeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.moveToNext
            .withUnretained(self)
            .bind(onNext: { owner, state in
                owner.parentViewModel.readyForNextButton.accept(state)
            })
            .disposed(by: disposeBag)
        
        termsAgreeLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                print("이용약관")
                ///이용약관 하이퍼링크 등록
            })
            .disposed(by: disposeBag)
        
        privacyAgreeLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                print("개인정보 취급방침")
                ///개인정보 취급방침 하이퍼링크 등록
            })
            .disposed(by: disposeBag)
    }
}
