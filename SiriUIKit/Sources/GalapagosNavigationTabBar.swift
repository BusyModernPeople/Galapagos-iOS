//
//  GalapagosNavigationTabBar.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/06/22.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit

public final class GalapagosNavigationTabBarView: UIView {
  
  public enum TabBarPages {
    case main
    case diary
    case community
    case myPage
  }
  
  // MARK: - UI
  
  public lazy var alertButton: UIButton = {
    let button = UIButton()
    button.setImage(SiriUIKitAsset._24x24alarmDefault.image, for: .normal)
    return button
  }()
  
  public lazy var searchButton: UIButton = {
    let button = UIButton()
    button.setImage(SiriUIKitAsset._24x24searchDefault.image, for: .normal)
    return button
  }()
  
  public lazy var settingButton: UIButton = {
    let button = UIButton()
    button.setImage(SiriUIKitAsset._24x24settingDefault.image, for: .normal)
    return button
  }()
  
  private let largeLabel: UILabel = {
    let label = UILabel()
    label.font = SiriUIKitFontFamily.Pretendard.bold.font(size: 28)
    label.textColor = SiriUIKitAsset.black제목DisplayHeadingBody.color
    return label
  }()
  
  private lazy var middleLabel: UILabel = {
    let label = UILabel()
    label.font = SiriUIKitFontFamily.Pretendard.bold.font(size: 18)
    label.textColor = SiriUIKitAsset.black제목DisplayHeadingBody.color
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
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = SiriUIKitAsset.white기본화이트.color
    setAddSubView()
    setConstraint()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Methods
  func setAddSubView() {
    self.addSubview(rightItemStack)
  }
  
  func setConstraint() {
    
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
    self.setLeftTitleText("Logo") // 후에 이미지로 교체 및 "" 변경
    self.addRightButton(self.alertButton)
  }
  
  private func setDiaryLogo() {
    self.setLeftTitleText("")
  }
  
  private func setCommunityLogo() {
    self.setLeftTitleText("커뮤니티")
//    self.addRightButton(self.searchButton) -> 피그마 보니까 없어진 것 같아요
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
