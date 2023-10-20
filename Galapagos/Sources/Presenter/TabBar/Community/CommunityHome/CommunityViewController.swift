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
	
	private lazy var communityListView: UIView = {
		let communityListView = UIView()
		communityListView.layer.masksToBounds = false
		communityListView.backgroundColor = GalapagosAsset.whiteDefaultWhite.color
		communityListView.layer.borderWidth = 0
		communityListView.layer.cornerRadius = 20
		communityListView.layer.shadowColor = GalapagosAsset.blackDisplayHeadingBody.color.withAlphaComponent(0.1).cgColor
		communityListView.layer.shadowOffset = CGSize(width: 0, height: 0)
		communityListView.layer.shadowRadius = 16.0
		communityListView.layer.shadowOpacity = 0.5
		return communityListView
	}()
	
	private lazy var freeCommunityCell: CommunityListCell = {
		let freeCommunityCell = CommunityListCell(title: "자유게시판", image: "32x32community")
		return freeCommunityCell
	}()
	
	private lazy var qnaCommunityCell: CommunityListCell = {
		let qnaCommunityCell = CommunityListCell(title: "QnA", image: "32x32qna")
		return qnaCommunityCell
	}()
	
	private lazy var notificationCommunityCell: CommunityListCell = {
		let notificationCommunityCell = CommunityListCell(title: "공지사항", image: "32x32speaker")
		return notificationCommunityCell
	}()
	
	private lazy var communityListVerticalStackView: UIStackView = {
		let communityListVerticalStackView = UIStackView()
		communityListVerticalStackView.axis = .horizontal
		communityListVerticalStackView.spacing = 24
		communityListVerticalStackView.distribution = .fillEqually
		communityListVerticalStackView.alignment = .fill
		communityListVerticalStackView.addArrangedSubview(freeCommunityCell)
		communityListVerticalStackView.addArrangedSubview(qnaCommunityCell)
		communityListVerticalStackView.addArrangedSubview(notificationCommunityCell)
		return communityListVerticalStackView
	}()
	
	private lazy var communityPopularListView: UIView = {
		let communityPopularListView = UIView()
		return communityPopularListView
	}()
	
	private lazy var communityPopularLabel: UILabel = {
		let label = UILabel()
		label.text = "커뮤니티 인기글"
		label.textColor = GalapagosAsset.blackDisplayHeadingBody.color
		label.font = GalapagosFontFamily.Pretendard.bold.font(size: 24)
		return label
	}()
	
	private lazy var pathOfPopularCommunityTab: GalapagosDynamicTabView = {
		let tab = GalapagosDynamicTabView(
			type: .inContents,
			titles: self.pathOfCategory
		)
		
		tab.rx.changedPage
			.drive { pageIndex in
				print("🍎 선택 된 페이지: \(pageIndex) 🍎")
			}
			.disposed(by: disposeBag)
		
		return tab
	}()
	
	// MARK: - Properties
	
	private let viewModel: CommunityViewModel
	private let pathOfCategory: [String] = ["조회 순", "좋아요 순", "댓글 순"]
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
			communityListView,
			communityPopularListView
		])
		
		communityListView.addSubview(communityListVerticalStackView)
		
		communityPopularListView.addSubviews([
			communityPopularLabel,
			pathOfPopularCommunityTab
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
		
		contentView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
			make.width.equalToSuperview()
			make.height.greaterThanOrEqualTo(
				view.safeAreaLayoutGuide
			)
			.offset(60)
			.priority(.low)
		}
		
		communityListView.snp.makeConstraints { make in
			make.top.equalToSuperview().galapagosOffset(offset: ._20)
			make.leading.equalToSuperview().offset(24)
			make.trailing.equalToSuperview().offset(-24)
			make.height.equalTo(100)
		}
		
		freeCommunityCell.snp.makeConstraints { make in
			make.height.equalTo(60)
			make.width.equalTo(80)
		}
		
		qnaCommunityCell.snp.makeConstraints { make in
			make.height.equalTo(60)
			make.width.equalTo(80)
		}
		
		notificationCommunityCell.snp.makeConstraints { make in
			make.height.equalTo(60)
			make.width.equalTo(80)
		}
		
		communityListVerticalStackView.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
		}
		
		communityPopularListView.snp.makeConstraints { make in
			make.top.equalTo(communityListView.snp.bottom).galapagosOffset(offset: ._40)
			make.leading.equalToSuperview().offset(24)
			make.trailing.equalToSuperview().offset(-24)
			make.bottom.equalTo(contentView.snp.bottom)
		}
		
		communityPopularLabel.snp.makeConstraints { make in
			make.top.horizontalEdges.equalToSuperview()
		}
		
		pathOfPopularCommunityTab.snp.makeConstraints { make in
			make.top.equalTo(communityPopularLabel.snp.bottom).galapagosOffset(offset: ._12)
			make.horizontalEdges.equalToSuperview()
		}
	}
	
	override func bind() {
		
	}
}
