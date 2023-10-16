//
//  CompleteSignUpView.swift
//  Galapagos
//
//  Created by 조용인 on 2023/06/23.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import SiriUIKit
import SnapKit
import UIKit


final class CompleteSignUpView: UIView {
	// MARK: - UI
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "반가워요!\n닉네임 님"
		label.numberOfLines = 2
		label.font = GalapagosFontFamily.Pretendard.bold.font(size: 28)
		label.textColor = GalapagosAsset.black제목DisplayHeadingBody.color
		return label
	}()
	
	private lazy var completeImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = GalapagosAsset.gray3DisableButtonBg.color
		imageView.layer.cornerRadius = 12
		
		return imageView
	}()
	
	private lazy var infoLabel: UILabel = {
		let label = UILabel()
		label.font = GalapagosFontFamily.Pretendard.medium.font(size: 18)
		label.textColor = GalapagosAsset.black제목DisplayHeadingBody.color
		return label
	}()
	
	private lazy var registerAnimalButton: GalapagosButton = {
		let button = GalapagosButton(
			isRound: false,
			iconTitle: nil,
			type: .usage(.inactive),
			title: "반려동물 등록하기"
		)
		return button
	}()
	
	private lazy var lookAroundAppButton: GalapagosButton = {
		let button = GalapagosButton(
			isRound: false,
			iconTitle: nil,
			type: .usage(.softInactive),
			title: "먼저 앱 둘러보기"
		)
		return button
	}()
	
	// MARK: - Properties
	private let parentViewModel: EmailSignUpViewModel
	private let viewModel: CompleteSignUpViewModel
	private let disposeBag = DisposeBag()
	
	
	// MARK: - Initializers
	
	public init(
		parentViewModel: EmailSignUpViewModel,
		viewModel: CompleteSignUpViewModel
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
			completeImageView,
			infoLabel,
			registerAnimalButton,
			lookAroundAppButton
		])
	}
	
	private func setConstraints() {
		titleLabel.snp.makeConstraints {
			$0.top.equalTo(self)
			$0.centerX.equalTo(self)
		}
		
		completeImageView.snp.makeConstraints {
			$0.top.equalTo(titleLabel.snp.bottom).offset(50)
			$0.centerX.equalTo(self)
			$0.width.height.equalTo(184)
		}
		
		infoLabel.snp.makeConstraints {
			$0.top.equalTo(completeImageView.snp.bottom).offset(32)
			$0.centerX.equalTo(self)
		}
		
		registerAnimalButton.snp.makeConstraints {
			$0.top.equalTo(infoLabel.snp.bottom).offset(132)
			$0.leading.trailing.equalTo(self).inset(24)
			$0.height.equalTo(56)
		}
		
		lookAroundAppButton.snp.makeConstraints {
			$0.top.equalTo(registerAnimalButton.snp.bottom).offset(12)
			$0.leading.trailing.equalTo(self).inset(24)
			$0.height.equalTo(56)
		}
		
	}
	
	private func bind() {
		let input = CompleteSignUpViewModel.Input(
			registerAnimalBtnTapped: registerAnimalButton.rx.tap.asObservable(),
			lookAroundBtnTapped: lookAroundAppButton.rx.tap.asObservable()
		)
		
		let output = viewModel.transform(input: input)
		
		output.lookAroundTap
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.parentViewModel.coordinator?.finish()
			})
			.disposed(by: disposeBag)
		
		output.registerTap
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.parentViewModel.coordinator?.finish()
			})
			.disposed(by: disposeBag)
	}
	
}
