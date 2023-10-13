//
//  EmailSignInViewController.swift
//  Galapagos
//
//  Created by 조용인 on 2023/06/11.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import SnapKit

import UIKit


class EmailSignInViewController: BaseViewController {
	
	// MARK: - UI
	private lazy var mockLabel: UILabel = {
		let label = UILabel()
		label.text = "이메일 로그인 페이지"
		label.textColor = GalapagosAsset.green.color
		label.font = GalapagosFontFamily.Pretendard.bold.font(size: 36)
		return label
	}()
	
	// MARK: - Properties
	private let viewModel: EmailSignInViewModel
	
	// MARK: - Initializers
	init(
		viewModel: EmailSignInViewModel
	) {
		self.viewModel = viewModel
		super.init()
	}
	
	// MARK: - LifeCycle
	
	// MARK: - Methods
	
	override func setConstraint() {
		mockLabel.snp.makeConstraints{ mockLabel in
			mockLabel.centerX.equalToSuperview()
			mockLabel.centerY.equalToSuperview()
		}
	}
	
	override func setAddSubView() {
		self.view.addSubviews([
			mockLabel
		])
	}
	
}
