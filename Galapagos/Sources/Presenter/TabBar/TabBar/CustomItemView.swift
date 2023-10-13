//
//  CustomItemView.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/06/28.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import SnapKit
import UIKit


final class CustomItemView: BaseView {
  
  //
  private var nameLabel = UILabel() // ⭐️이미지와 라벨 분리 시 활성화 코드 (아래 주석 전부 포함)
  private let iconImageView = UIImageView()
  private let containerView = UIView()
  
  let item: TabBarCoordinatorFlow
  
  var isSelected = false {
    didSet {
      animateItems()
    }
  }
  
  init(with item: TabBarCoordinatorFlow) {
    self.item = item
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setAddSubView() {
    self.addSubview(containerView)
    // containerView.addSubviews([nameLabel, iconImageView])
    containerView.addSubviews([iconImageView])
  }
  
  override func setAttribute() {
    self.backgroundColor = .clear
    
    // nameLabel.font = GalapagosFontFamily.Pretendard.semiBold.font(size: 12)
    // nameLabel.text = item.tabBarItem.title
    // nameLabel.textAlignment = .center
    
    iconImageView.image = isSelected ? item.tabBarItem.selectedImage : item.tabBarItem.image
  }
  
  override func setConstraint() {
    containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.center.equalToSuperview()
    }
    
    iconImageView.snp.makeConstraints {
      $0.width.equalTo(54)
      $0.height.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
    
    //    nameLabel.snp.makeConstraints {
    //      $0.bottom.leading.trailing.equalToSuperview()
    //      $0.top.equalTo(iconImageView.snp.bottom).offset(5)
    //      $0.height.equalTo(16)
    //    }
  }
  
  private func animateItems() {
    // UIView.animate(withDuration: 0.05) { [unowned self] in
    // self.nameLabel.textColor = self.isSelected ? GalapagosAsset.green.color : GalapagosAsset.gray4SubText.color
    
    // }
    
    UIView.transition(
      with: iconImageView,
      duration: 0.05,
      options: .transitionCrossDissolve
    ) { [unowned self] in
      self.iconImageView.image = self.isSelected ? self.item.tabBarItem.selectedImage : self.item.tabBarItem.image
    }
  }
}
