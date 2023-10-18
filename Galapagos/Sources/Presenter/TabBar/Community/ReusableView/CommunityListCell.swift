//
//  CommunityListCell.swift
//  Galapagos
//
//  Created by Siri on 2023/10/18.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import SiriUIKit
import SnapKit
import UIKit

final class CommunityListCell: UIView {
	
	// MARK: - UI
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.text = title
		label.font = GalapagosFontFamily.Pretendard.bold.font(size: 14)
		label.textColor = GalapagosAsset.blackDisplayHeadingBody.color
		return label
	}()
	
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: image)
		return imageView
	}()
	
	// MARK: - Properties
	private var title: String
	private var image: String
	
	init(
		title: String,
		image: String
	) {
		self.title = title
		self.image = image
		super.init(frame: .zero)
		
		setAddSubView()
		setConstraint()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setAddSubView() {
		addSubview(titleLabel)
		addSubview(imageView)
	}
	
	func setConstraint() {
		
		imageView.snp.makeConstraints {
			$0.top.equalToSuperview()
			$0.centerX.equalToSuperview()
		}
		
		titleLabel.snp.makeConstraints {
			$0.top.equalTo(imageView.snp.bottom).galapagosOffset(offset: ._8)
			$0.centerX.equalToSuperview()
		}
		
	}
	
	
}
