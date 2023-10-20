//
//  GalapagosAlert.swift
//  Galapagos
//
//  Created by Siri on 2023/10/20.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//
import Foundation

import RxCocoa
import RxGesture
import RxSwift

import SnapKit

import UIKit

public final class GalapagosAlert: UIView{
	
	// MARK: - UI
	
	private lazy var mainTitle: UILabel = {
		let label = UILabel()
		label.font = SiriUIKitFontFamily.Pretendard.medium.font(size: 16)
		label.textColor = SiriUIKitAsset.blackDisplayHeadingBody.color
		label.text = title
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()
	
	private lazy var bodyLabel: UILabel = {
		let label = UILabel()
		label.font = SiriUIKitFontFamily.Pretendard.medium.font(size: 14)
		label.textColor = SiriUIKitAsset.gray2CaptionSmallPlaceholderText.color
		label.text = body
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()
	
	private lazy var cancelButton: UIButton = {
		let button = UIButton()
		button.setTitle(cancelTitle, for: .normal)
		button.titleLabel?.font = SiriUIKitFontFamily.Pretendard.bold.font(size: 14)
		button.setTitleColor(SiriUIKitAsset.gray1Body.color, for: .normal)
		button.backgroundColor = SiriUIKitAsset.whiteDefaultWhite.color
		button.layer.borderWidth = 1
		button.layer.borderColor = SiriUIKitAsset.gray1Outline.color.cgColor
		button.layer.cornerRadius = 20
		return button
	}()
	
	private lazy var actionButton: UIButton = {
		let button = UIButton()
		button.setTitle(actionTitle, for: .normal)
		button.titleLabel?.font = SiriUIKitFontFamily.Pretendard.bold.font(size: 14)
		button.setTitleColor(SiriUIKitAsset.whiteDefaultWhite.color, for: .normal)
		button.backgroundColor = SiriUIKitAsset.icon.color
		button.layer.borderWidth = 1
		button.layer.borderColor = SiriUIKitAsset.gray1Outline.color.cgColor
		button.layer.cornerRadius = 20
		return button
	}()
	
	private lazy var buttonStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.addArrangedSubview(cancelButton)
		stackView.addArrangedSubview(actionButton)
		stackView.axis = .horizontal
		stackView.spacing = 8
		stackView.distribution = .fillEqually
		return stackView
	}()
	
	// MARK: - Properties
	
	var disposeBag = DisposeBag()
	
	private var title: String
	private var body: String?
	private var cancelTitle: String
	private var actionTitle: String
	
	public var alertAction = PublishRelay<Bool>()
	
	// MARK: - Initializers
	
	/// 버튼의 `title`, `body`, `cancelTitle`, `actionTitle`을 설정합니다.
	/// - Parameters:
	///   - title : Alert의 메인 타이틀을 결정합니다.
	///   - body : Alert의 본문을 결정합니다.
	///   - cancelTitle : Alert의 취소 버튼의 타이틀을 결정합니다.
	///   - actionTitle: Alert의 확인 버튼의 타이틀을 결정합니다.
	public init(title: String, body: String?, cancelTitle: String, actionTitle: String) {
		self.title = title
		self.body = body
		self.cancelTitle = cancelTitle
		self.actionTitle = actionTitle
		super.init(frame: .zero)
		
		self.backgroundColor = SiriUIKitAsset.whiteDefaultWhite.color
		self.layer.cornerRadius = 16
		
		self.setAddSubView()
		self.setConstraint()
		
		self.bind()
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	// MARK: - LifeCycle
	
	// MARK: - Methods
	
	private func setAddSubView() {
		self.addSubview(mainTitle)
		self.addSubview(bodyLabel)
		self.addSubview(buttonStackView)
	}
	
	private func setConstraint() {
		
		mainTitle.snp.makeConstraints { make in
			if body != nil {
				make.top.equalToSuperview().offset(40)
			} else {
				make.top.equalToSuperview().offset(45)
			}
			make.width.equalTo(228)
			make.centerX.equalToSuperview()
		}
		
		bodyLabel.snp.makeConstraints { make in
			make.top.equalTo(mainTitle.snp.bottom).offset(10)
			make.leading.equalToSuperview().offset(20)
			make.trailing.equalToSuperview().offset(-20)
		}
		
		buttonStackView.snp.makeConstraints { make in
			make.bottom.equalToSuperview().offset(-30)
			make.leading.equalToSuperview().offset(20)
			make.trailing.equalToSuperview().offset(-20)
		}
		
		cancelButton.snp.makeConstraints { make in
			make.height.equalTo(40)
		}
		
		actionButton.snp.makeConstraints { make in
			make.height.equalTo(40)
		}
	}
	
	private func bind() {
		cancelButton.rx.tap
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.alertAction.accept(false)
			})
			.disposed(by: disposeBag)
		
		actionButton.rx.tap
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.alertAction.accept(true)
			})
			.disposed(by: disposeBag)
	}
	
}
