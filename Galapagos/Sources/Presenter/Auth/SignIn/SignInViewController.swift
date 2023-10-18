//
//  SignInViewController.swift
//  Galapagos
//
//  Created by 조용인 on 2023/06/07.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//
import Foundation

import RxCocoa
import RxSwift

import SiriUIKit
import SnapKit

import UIKit

class SignInViewController: BaseViewController {
	
	// MARK: - UI
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "갈파 텍스트 로고"
		label.textColor = GalapagosAsset.green.color
		label.font = GalapagosFontFamily.Pretendard.bold.font(size: 28)
		return label
	}()
	
	private lazy var logoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.backgroundColor = GalapagosAsset.gray3DisableButtonBg.color
		imageView.clipsToBounds = true
		imageView.cornerRadius = 12
		return imageView
	}()
	
	private lazy var galapagosInfoLable: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.contentMode = .center
		label.textAlignment = .center
		let text = "동물들의 지상낙원,\n갈라파고스에 오신 것을 환영해요!"
		let attributedString = NSMutableAttributedString(string: text)
		
		let blackAttributes: [NSAttributedString.Key: Any] =
		[.foregroundColor: GalapagosAsset.blackDisplayHeadingBody.color]
		let greenAttributes: [NSAttributedString.Key: Any] =
		[.foregroundColor: GalapagosAsset.green.color]
		let galapagosRange = (text as NSString).range(of: "갈라파고스")
		attributedString.addAttributes(blackAttributes, range: NSRange(location: 0, length: text.count))
		attributedString.addAttributes(greenAttributes, range: galapagosRange)
		label.attributedText = attributedString
		label.font = GalapagosFontFamily.Pretendard.semiBold.font(size: 18)
		return label
	}()
	
	private lazy var kakaoSignInButton: UIButton = {
		let button = UIButton()
		button.layer.cornerRadius = button.frame.height/2
		button.setImage(GalapagosAsset.snsKakao.image, for: .normal)
		button.borderWidth = 0
		return  button
	}()
	
	private lazy var naverSignInButton: UIButton = {
		let button = UIButton()
		button.layer.cornerRadius = button.frame.height/2
		button.setImage(GalapagosAsset.snsNaver.image, for: .normal)
		button.borderWidth = 0
		return  button
	}()
	
	private lazy var appleSignInButton: UIButton = {
		let button = UIButton()
		button.layer.cornerRadius = button.frame.height/2
		button.setImage(GalapagosAsset.snsApple.image, for: .normal)
		button.borderWidth = 0
		return  button
	}()
	
	private lazy var googleSignInButton: UIButton = {
		let button = UIButton()
		button.setImage(GalapagosAsset.snsGoogle.image, for: .normal)
		button.borderWidth = 0
		return  button
	}()
	
	private lazy var emailSignUpLabel: UILabel = {
		let label = UILabel()
		let text = "이메일 회원가입"
		let attributedString = NSMutableAttributedString(string: text)
		
		let underLineAttributes: [NSAttributedString.Key: Any] = [
			.underlineStyle: NSUnderlineStyle.single.rawValue,
			.baselineOffset : NSNumber(value: 3)
		]
		attributedString.addAttributes(underLineAttributes, range: NSRange(location: 0, length: text.count))
		label.attributedText = attributedString
		label.font = GalapagosFontFamily.Pretendard.medium.font(size: 16)
		return label
	}()
	
	private lazy var emailSignInLabel: UILabel = {
		let label = UILabel()
		let text = "이메일 로그인"
		let attributedString = NSMutableAttributedString(string: text)
		
		let underLineAttributes: [NSAttributedString.Key: Any] = [
			.underlineStyle: NSUnderlineStyle.single.rawValue,
			.baselineOffset : NSNumber(value: 3)
		]
		attributedString.addAttributes(underLineAttributes, range: NSRange(location: 0, length: text.count))
		label.attributedText = attributedString
		label.font = GalapagosFontFamily.Pretendard.medium.font(size: 16)
		return label
	}()
	
	private lazy var separatorView: UIView = {
		let separator = UIView()
		separator.backgroundColor = GalapagosAsset.gray5DisableText2.color
		return separator
	}()
	
	private lazy var socialLoginStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .top
		stackView.distribution = .fillProportionally
		stackView.spacing = 20
		return stackView
	}()
	
	private lazy var emailLoginStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .center
		stackView.distribution = .equalSpacing
		stackView.spacing = 10
		return stackView
	}()
	
	// MARK: - Properties
	private let viewModel: SignInViewModel
	
	// MARK: - Initializers
	init(
		viewModel: SignInViewModel
	) {
		self.viewModel = viewModel
		super.init()
	}
	
	// MARK: - LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	// MARK: - Methods
	override func setConstraint() {
		titleLabel.snp.makeConstraints{ titleLable in
			titleLable.centerX.equalToSuperview()
			titleLable.centerY.equalToSuperview().multipliedBy(0.4)
		}
		
		logoImageView.snp.makeConstraints { logoImageView in
			logoImageView.centerX.equalToSuperview()
			logoImageView.top.equalTo(titleLabel.snp.bottom).multipliedBy(1.2)
			logoImageView.height.width.equalTo(185)
		}
		
		galapagosInfoLable.snp.makeConstraints{ infoLabel in
			infoLabel.centerX.equalToSuperview()
			infoLabel.top.equalTo(logoImageView.snp.bottom).multipliedBy(1.1)
		}
		
		kakaoSignInButton.snp.makeConstraints { kakaoButton in
			kakaoButton.width.height.equalTo(56)
		}
		
		naverSignInButton.snp.makeConstraints { naverButton in
			naverButton.width.height.equalTo(56)
		}
		
		appleSignInButton.snp.makeConstraints { appleButton in
			appleButton.width.height.equalTo(56)
		}
		
		googleSignInButton.snp.makeConstraints { googleButton in
			googleButton.width.height.equalTo(56)
		}
		
		socialLoginStackView.snp.makeConstraints{ socialStack in
			socialStack.centerX.equalToSuperview()
			socialStack.top.equalTo(galapagosInfoLable.snp.bottom).multipliedBy(1.25)
		}
		
		separatorView.snp.makeConstraints{ separator in
			separator.width.equalTo(0.6)
			separator.height.equalTo(16)
		}
		
		emailLoginStackView.snp.makeConstraints{ emailStack in
			emailStack.centerX.equalToSuperview()
			emailStack.top.equalTo(socialLoginStackView.snp.bottom)
				.offset(20)
		}
	}
	override func setAddSubView() {
		self.view.addSubviews([
			titleLabel,
			logoImageView,
			galapagosInfoLable,
			socialLoginStackView,
			emailLoginStackView
		])
		
		[ kakaoSignInButton,
			naverSignInButton,
			appleSignInButton,
			googleSignInButton ].forEach { self.socialLoginStackView.addArrangedSubview($0) }
		
		[	emailSignUpLabel,
			separatorView,
			emailSignInLabel ].forEach { self.emailLoginStackView.addArrangedSubview($0) }
	}
	
	override func bind() {
		
		
		let emailSignUpBtnTapped = emailSignUpLabel.rx.tapGesture().when(.recognized).map{_ in }.asObservable()
		let emailSignInBtnTapped = emailSignInLabel.rx.tapGesture().when(.recognized).map{_ in }.asObservable()
		let googleSignInBtnTapped = googleSignInButton.rx.tap
			.asObservable()
		
		let input = SignInViewModel.Input(
			emailSignUpBtnTapped: emailSignUpBtnTapped,
			emailSignInBtnTapped: emailSignInBtnTapped,
			googleSignInBtnTapped: googleSignInBtnTapped
		)
		
		_ = viewModel.transform(input: input)
	}
}
