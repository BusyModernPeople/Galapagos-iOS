//
//  EmailSignUpViewController.swift
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

class EmailSignUpViewController: BaseViewController {
	
	// MARK: - UI
	
	private lazy var navigationBar: GalapagosNavigationBarView = {
		let navigationBar = GalapagosNavigationBarView()
		navigationBar.setTitleText("")
		return navigationBar
	}()
	
	private lazy var termsAndConditionsView: TermsAndConditionsView = {
		let view = TermsAndConditionsView(
			parentViewModel: viewModel,
			viewModel: TermsAndConditionsViewModel()
		)
		return view
	}()
	
	private lazy var emailCheckView: EmailCheckView = {
		let view = EmailCheckView(
			parentViewModel: viewModel,
			viewModel: EmailCheckViewModel()
		)
		return view
	}()
	
	private lazy var passwordCheckView: PasswordCheckView = {
		let view = PasswordCheckView(
			parentViewModel: viewModel,
			viewModel: PasswordCheckViewModel())
		return view
	}()
	
	private lazy var nicknameCheckView: NicknameCheckView = {
		let view = NicknameCheckView(
			parentViewModel: viewModel,
			viewModel: NicknameCheckViewModel()
		)
		return view
	}()
	
	private lazy var completeSignUpView: CompleteSignUpView = {
		let view = CompleteSignUpView(
			parentViewModel: viewModel,
			viewModel: CompleteSignUpViewModel()
		)
		return view
	}()
	
	private lazy var galapagosPager: GalapagosProgressPager = {
		let progressPager = GalapagosProgressPager(pages: [
			termsAndConditionsView,
			emailCheckView,
			passwordCheckView,
			nicknameCheckView,
			completeSignUpView
		])
		return progressPager
	}()
	
	private lazy var nextButton: GalapagosButton = {
		let button = GalapagosButton(
			isRound: false,
			iconTitle: nil,
			type: .usage(.disabled),
			title: "다음"
		)
		return button
	}()
	
	// MARK: - Properties
	private let viewModel: EmailSignUpViewModel
	
	// MARK: - Initializers
	init(
		viewModel: EmailSignUpViewModel
	) {
		self.viewModel = viewModel
		super.init()
		
		setBind()
	}
	
	// MARK: - LifeCycle
	
	// MARK: - Methods
	
	override func setConstraint() {
		navigationBar.snp.makeConstraints{ navigationBar in
			navigationBar.top.equalTo(self.view.safeAreaLayoutGuide)
			navigationBar.leading.trailing.equalToSuperview()
			navigationBar.height.equalTo(50)
		}
		
		galapagosPager.snp.makeConstraints{ galapagosPager in
			galapagosPager.top.equalTo(navigationBar.snp.bottom).offset(10)
			galapagosPager.leading.trailing.equalToSuperview()
			galapagosPager.bottom.equalToSuperview()
		}
		
		nextButton.snp.makeConstraints{ nextButton in
			nextButton.centerX.equalToSuperview()
			nextButton.width.equalToSuperview().multipliedBy(0.9)
			nextButton.bottom.equalToSuperview().inset(50)
			nextButton.height.equalTo(56)
			
		}
		
	}
	
	override func setAddSubView() {
		self.view.addSubviews([
			navigationBar,
			galapagosPager,
			nextButton
		])
	}
	
	private func setBind() {
		let input = EmailSignUpViewModel.Input(
			backButtonTapped: navigationBar.backButton.rx.tap.asObservable(),
			nextButtonTapped: nextButton.rx.tap.asObservable(),
			nowPage: galapagosPager.getCurrentPage()
		)
		
		let output = viewModel.transform(input: input)
				
		nextButton.rx.tap
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.galapagosPager.nextPage()
			})
			.disposed(by: disposeBag)
		
		navigationBar.backButton.rx.tap
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.galapagosPager.previousPage()
			})
			.disposed(by: disposeBag)
		
		output.nextButtonHidden
			.debug()
			.asObservable()
			.withUnretained(self)
			.subscribe(onNext: { owner, isHidden in
				owner.nextButton.isHidden = isHidden
			})
			.disposed(by: disposeBag)
		
		output.readyForNextButton
			.asObservable()
			.withUnretained(self)
			.subscribe(onNext: { owner, isActive in
				isActive
				? owner.nextButton.makeCustomState(type: .fill)
				: owner.nextButton.makeCustomState(type: .usage(.disabled))
			})
			.disposed(by: disposeBag)
	}
}
