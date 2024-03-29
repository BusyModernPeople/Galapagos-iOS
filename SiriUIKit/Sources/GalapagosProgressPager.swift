//
//  GalapagosProgressPager.swift
//  SiriUIKit
//
//  Created by 조용인 on 2023/06/19.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//
import Foundation

import RxCocoa
import RxSwift

import SnapKit

import UIKit

public final class GalapagosProgressPager: UIView {
	// MARK: - UI
	
	private lazy var progressView: UIProgressView = {
		let progressView = UIProgressView()
		progressView.progressTintColor = SiriUIKitAsset.green.color
		progressView.trackTintColor = SiriUIKitAsset.gray3DisableButtonBg.color
		progressView.progress = 0.02
		return progressView
	}()
	
	private lazy var pagerScrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.isPagingEnabled = true
		scrollView.isScrollEnabled = false
		scrollView.showsHorizontalScrollIndicator = false
		
		return scrollView
	}()
	
	// MARK: - Properties
	
	private let disposeBag = DisposeBag()
	private let currentPage = BehaviorRelay(value: 0)
	
	private var pages: [UIView] = []
	private var pagesCount: Int
	
	// MARK: - Initializers
	public init(
		pages: [UIView]
	) {
		self.pages = pages
		self.pagesCount = pages.count
		
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
	public override func layoutSubviews() {
		super.layoutSubviews()
		
		for (index, page) in pages.enumerated() {
			pagerScrollView.addSubview(page)
			page.snp.makeConstraints { make in
				make.top.equalTo(progressView.snp.bottom).offset(40)
				make.bottom.equalTo(self.snp.bottom)
				make.width.equalTo(self.frame.size.width)
				make.leading.equalToSuperview().offset(CGFloat(index) * self.frame.size.width)
			}
		}
		pagerScrollView.contentSize = CGSize(
			width: self.frame.size.width * CGFloat(pages.count),
			height: self.frame.size.height
		)
	}
	
	private func setAddSubView() {
		self.addSubview(progressView)
		self.addSubview(pagerScrollView)
	}
	
	private func setConstraint() {
		
		self.progressView.snp.makeConstraints{ progressView in
			progressView.top.equalTo(self).offset(10)
			progressView.height.equalTo(8)
			progressView.leading.trailing.equalTo(self).inset(24)
		}
		
		self.pagerScrollView.snp.makeConstraints { scrollView in
			scrollView.top.equalTo(progressView.snp.bottom)
			scrollView.leading.trailing.bottom.equalTo(self)
		}
	}
	
	private func bind() {
		currentPage.asObservable()
			.map { Float($0) / Float(self.pagesCount - 1) }
			.withUnretained(self)
			.subscribe(onNext: { owner, progress in
				progress == 0
				? owner.progressView.setProgress(0.02, animated: true)
				: owner.progressView.setProgress(progress, animated: true)
			})
			.disposed(by: disposeBag)
		
		currentPage.asObservable()
			.subscribe(onNext: { [weak self] page in
				guard let self = self else { return }
				let xOffset = CGFloat(page) * self.frame.size.width
				self.pagerScrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
			})
			.disposed(by: disposeBag)
		
	}
	
	public func nextPage() {
		currentPage.accept(currentPage.value + 1)
	}
	
	public func previousPage() {
		currentPage.accept(currentPage.value - 1)
	}
	
	public func getCurrentPage() -> Observable<Int> {
		return currentPage.asObservable()
	}
	
}
