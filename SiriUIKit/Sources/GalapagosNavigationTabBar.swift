//
//  GalapagosNavigationTabBar.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/06/22.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit

public final class GalapagosNavigationTabBarView: BaseView {
  
  public enum TabBarPages {
    case main
    case diary
    case community
    case myPage
  }
  
  // MARK: - UI
  
  public lazy var alertButton: UIButton = {
    let button = UIButton()
    button.setImage(SiriUIKitAsset.appBarNoti24x24.image, for: .normal)
    return button
  }()
  
  public lazy var searchButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal) //임시 이미지
    return button
  }()
  
  public lazy var settingButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "gearshape"), for: .normal) //임시 이미지
    return button
  }()
  
  private let largeLabel: UILabel = {
    let label = UILabel()
    label.font = SiriUIKitFontFamily.Pretendard.bold.font(size: 28)
    label.textColor = SiriUIKitAsset.blackHeading.color
    return label
  }()
  
  private lazy var middleLabel: UILabel = {
    let label = UILabel()
    label.font = SiriUIKitFontFamily.Pretendard.bold.font(size: 18)
    label.textColor = SiriUIKitAsset.blackHeading.color
    return label
  }()
  
  private lazy var rightItemStack: UIStackView = {
    let horizontalStackView = UIStackView()
    horizontalStackView.axis = .horizontal
    horizontalStackView.distribution = .equalSpacing
    horizontalStackView.spacing = 8
    return horizontalStackView
  }()
  
  // MARK: - Properties
  
  // MARK: - Initializers
  
  // MARK: - Methods
  override func setAddSubView() {
    super.setAddSubView()
    self.addSubview(rightItemStack)
  }
  
  override func setConstraint() {
    super.setConstraint()

    self.rightItemStack.snp.makeConstraints{ horizontalStack in
      horizontalStack.centerY.equalToSuperview()
      horizontalStack.trailing.equalToSuperview().offset(-24)
    }
  }
  
  public func setPageType(_ tabBar: TabBarPages) {
    switch tabBar {
    case .main:
      setMainLogo()
    case .diary:
      setDiaryLogo()
    case .community:
      setCommunityLogo()
    case .myPage:
      setMyPageLogo()
    }
  }
  
  private func setMainLogo() {
    self.setLeftTitleText("Logo") //후에 이미지로 교체 및 "" 변경
    self.addRightButton(self.alertButton)
  }
  
  private func setDiaryLogo() {
    self.setLeftTitleText("다이어리")
  }
  
  private func setCommunityLogo() {
    self.setLeftTitleText("커뮤니티")
    self.addRightButton(self.searchButton)
    self.addRightButton(self.alertButton)
  }
  
  private func setMyPageLogo() {
    self.setMiddleTitleText("마이 페이지")
    self.addRightButton(self.settingButton)
  }
  
  private func addRightButton(_ button: UIButton) {
    button.snp.makeConstraints{ button in
      button.height.width.equalTo(24)
    }
    self.rightItemStack.addArrangedSubview(button)
  }
  
  private func setLeftTitleText(_ text: String?) {
    self.addSubview(self.largeLabel)
    
    self.largeLabel.text = text
    largeLabel.snp.makeConstraints{ largeLabel in
      largeLabel.centerY.equalToSuperview()
      largeLabel.leading.equalToSuperview().offset(24)
    }
  }
  
  private func setMiddleTitleText(_ text: String?) {
    self.addSubview(self.middleLabel)
    
    self.middleLabel.text = text
    middleLabel.snp.makeConstraints{ middleLabel in
      middleLabel.centerX.centerY.equalToSuperview()
    }
  }
}
