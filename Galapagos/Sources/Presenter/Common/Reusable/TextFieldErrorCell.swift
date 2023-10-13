//
//  TextFieldErrorCell.swift
//  Galapagos
//
//  Created by 조용인 on 2023/07/07.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit

import SnapKit



final class TextFieldErrorCell: UIView {
	// MARK: - UI
	
	
	
	private lazy var checkImage: UIImageView = {
		let imageView = UIImageView()
		imageView.image = GalapagosAsset._16x16checkDefault.image
		return imageView
	}()
	
	private lazy var errorMessageLabel: UILabel = {
		let label = UILabel()
		label.text = errorMessage
		label.textColor = GalapagosAsset.gray5DisableText2.color
		label.font = GalapagosFontFamily.Pretendard.medium.font(size: 14)
		return label
	}()
	
	private lazy var errerCellStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [checkImage, errorMessageLabel])
		stackView.axis = .horizontal
		stackView.spacing = 4
		return stackView
	}()
	
	
	// MARK: - Properties
	private let errorMessage: String
	public var passwordErrorCase: PasswordErrorColorCase = .error {
		didSet {
			errorMessageLabel.textColor = passwordErrorCase.color
			checkImage.image = passwordErrorCase.image
		}
	}
	
	
	// MARK: - Initializers
	init(
		errorMessage: String
	) {
		self.errorMessage = errorMessage
		super.init(frame: .zero)
		
		addView()
		setConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - LifeCycle
	
	// MARK: - Methods
	
	private func addView() {
		self.addSubview(errerCellStackView)
	}
	
	private func setConstraints() {
		
		errerCellStackView.snp.makeConstraints {
			$0.top.bottom.equalToSuperview()
			$0.leading.trailing.equalToSuperview()
		}
	}
	
	func changeState(state: PasswordErrorColorCase){
		self.passwordErrorCase = state
	}
	
}

enum PasswordErrorColorCase {
	case error, success
	
	var color: UIColor {
		switch self {
		case .error:
			return GalapagosAsset.gray5DisableText2.color
		case .success:
			return GalapagosAsset.green.color
		}
	}
	
	var image: UIImage {
		switch self {
		case .error:
			return GalapagosAsset._16x16checkDefault.image
		case .success:
			return GalapagosAsset._16x16checkActive.image
		}
	}
	
}
