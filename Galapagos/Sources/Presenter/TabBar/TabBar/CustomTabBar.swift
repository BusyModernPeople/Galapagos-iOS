//
//  CustomTabBar.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/06/28.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import RxCocoa
import RxGesture
import RxSwift
import UIKit

final class CustomTabBar: BaseView {
  
  var itemTapped: Observable<Int> { itemTappedSubject.asObservable() }
  private lazy var customItemViews: [CustomItemView] = [mainItem, diaryItem, communityItem, myPageItem]
  
  private let itemStackView = {
    var stackView = UIStackView()
    stackView.distribution = .fillEqually
    stackView.alignment = .top
    return stackView
  }()
  private let mainItem = CustomItemView(with: .main)
  private let diaryItem = CustomItemView(with: .diaryList)
  private let communityItem = CustomItemView(with: .community)
  private let myPageItem = CustomItemView(with: .mypage)
  
  private let itemTappedSubject = PublishSubject<Int>()
  
  init() {
    super.init(frame: .zero)
    setShadow()
    selectItem(index: 0)
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setAddSubView() {
    self.addSubview(itemStackView)
    
    customItemViews.forEach { subview in
      itemStackView.addArrangedSubview(subview)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  override func setAttribute() { // 보강 필요
    self.layer.cornerRadius = 20
    self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    
    itemStackView.snp.makeConstraints { make in
      make.top.equalTo(self.snp.top).offset(10) // 유동적으로 바뀌게 만들어주기, 보류
      make.horizontalEdges.equalToSuperview()
    }
  }
  
  func selectItem(index: Int) {
    itemTappedSubject.onNext(index)
  }
  
  func changeImage(index: Int) {
    customItemViews.forEach { $0.isSelected = $0.item.rawValue == index }
  }
  
  func setShadow() {
    self.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
    self.layer.shadowOffset = CGSize(width: 0, height: -3)
    self.layer.shadowOpacity = 1
    self.layer.shadowRadius = 10
    self.layer.masksToBounds = false
  }
  
  // MARK: - Bindings
  
  override func bind() {
    mainItem.rx.tapGesture()
      .when(.recognized)
      .bind { [weak self] _ in
        guard let self = self else { return }
        self.mainItem.animateClick {
          self.selectItem(index: self.mainItem.item.rawValue)
        }
      }
      .disposed(by: disposeBag)
    
    diaryItem.rx.tapGesture()
      .when(.recognized)
      .bind { [weak self] _ in
        guard let self = self else { return }
        self.diaryItem.animateClick {
          self.selectItem(index: self.diaryItem.item.rawValue)
        }
      }
      .disposed(by: disposeBag)
    
    communityItem.rx.tapGesture()
      .when(.recognized)
      .bind { [weak self] _ in
        guard let self = self else { return }
        self.communityItem.animateClick {
          self.selectItem(index: self.communityItem.item.rawValue)
        }
      }
      .disposed(by: disposeBag)
    
    myPageItem.rx.tapGesture()
      .when(.recognized)
      .bind { [weak self] _ in
        guard let self = self else { return }
        self.myPageItem.animateClick {
          self.selectItem(index: self.myPageItem.item.rawValue)
        }
      }
      .disposed(by: disposeBag)
  }
}
