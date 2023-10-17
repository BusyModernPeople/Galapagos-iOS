//
//  CommunityViewController.swift
//  Galapagos
//
//  Created by Siri on 2023/10/17.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import SiriUIKit
import SnapKit
import UIKit


final class CommunityViewController: BaseViewController {
	
	// MARK: - UI
	
	private var shadowView = RadiusBoxView(radius: 8, style: .shadow)
	
	private lazy var navigationBar: GalapagosNavigationTabBarView = {
		let navigationBar = GalapagosNavigationTabBarView()
		navigationBar.setPageType(.community)
		return navigationBar
	}()
	
	private lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.showsVerticalScrollIndicator = false
		return scrollView
	}()
	
	private lazy var contentView: UIView = {
		let contentView = UIView()
		return contentView
	}()
	
	// MARK: - Properties
	
	private let viewModel: CommunityViewModel
	
	// MARK: - Initializers
	
	init(viewModel: CommunityViewModel) {
		print("🔥 CommunityViewController")
		self.viewModel = viewModel
		super.init()
	}
	
	// MARK: - Methods
	
	override func setAddSubView() {
		self.view.addSubviews([
			navigationBar,
			scrollView
		])
		
		scrollView.addSubview(contentView)
		contentView.addSubviews([
			// 추가할 뷰는 여기에다가~
		])
	}
	
	override func setConstraint() {
		navigationBar.snp.makeConstraints { navigationBar in
			navigationBar.top.equalTo(self.view.safeAreaLayoutGuide)
			navigationBar.leading.trailing.equalToSuperview()
			navigationBar.height.equalTo(56)
		}
		
		scrollView.snp.makeConstraints { make in
			make.top.equalTo(navigationBar.snp.bottom)
			make.leading.trailing.bottom.equalToSuperview()
		}
		
		// contentView의 제약 조건 설정
		contentView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
			make.width.equalToSuperview()
			make.height.greaterThanOrEqualTo(
				view.safeAreaLayoutGuide
			)
			.offset(60)
			.priority(.low)
		}
	}
	
	override func bind() {
		
	}
}
