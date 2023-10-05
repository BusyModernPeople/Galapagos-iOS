//
//  GalapagosProgressPager.swift
//  SiriUIKit
//
//  Created by 조용인 on 2023/06/19.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture
import SnapKit

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
    public var pagesCount: Int
    
    fileprivate var pages: [UIView] = []
    
    // MARK: - Initializers
    public init(
        pages: [UIView]
    ) {
        self.pages = pages
        self.pagesCount = pages.count
        
        super.init(frame: .zero)
        setAddSubView()
        setConstraint()
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
        pagerScrollView.contentSize = CGSize(width: self.frame.size.width * CGFloat(pages.count), height: self.frame.size.height)
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
    
    public func nextPage(animated: Bool, next: CGFloat) {
        let nextXPoint: CGFloat = CGFloat(getCurrentPage()) + next
        let nextPoint = CGPoint(x:  nextXPoint * self.frame.size.width, y: 0)
        pagerScrollView.setContentOffset(nextPoint, animated: animated)
        setNextProgress(animated: animated)
    }
    
    public func previousPage(animated: Bool, previous: CGFloat) {
        let previousXPoint: CGFloat = CGFloat(getCurrentPage()) - previous
        let previousPoint = CGPoint(x:  previousXPoint * self.frame.size.width, y: 0)
        pagerScrollView.setContentOffset(previousPoint, animated: animated)
        setPreviousProgress(animated: animated)
    }
    
    public func setNextProgress(animated: Bool) {
        let progress = Float(getCurrentPage() + 1) / Float(pagesCount - 1)
        progressView.setProgress(progress, animated: animated)
    }
    
    public func setPreviousProgress(animated: Bool) {
        var progress = Float(0.0)
        if getCurrentPage() == 1 {
            progress = 0.02
        } else {
            progress = Float(getCurrentPage() - 1) / Float(pagesCount - 1)
        }
        progressView.setProgress(progress, animated: animated)
    }
    
    public func getCurrentPage() -> Int {
        let page = Int(pagerScrollView.contentOffset.x / self.frame.size.width)
        return page
    }
    
}
