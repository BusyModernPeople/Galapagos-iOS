//
//  GalapagosNavigationBar.swift
//  SiriUIKit
//
//  Created by 조용인 on 2023/06/13.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import SnapKit
import UIKit

public final class GalapagosNavigationBarView: UIView {
  
  // MARK: - UI
  public lazy var backButton: UIButton = {
    let button = UIButton()
    button.setImage(SiriUIKitAsset._24x24arrowLeft.image, for: .normal)
    return button
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = SiriUIKitFontFamily.Pretendard.semiBold.font(size: 18)
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
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setAddSubView()
    self.setConstraint()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Methods
  private func setAddSubView() {
    self.addSubview(backButton)
    self.addSubview(rightItemStack)
  }
  
  private func setConstraint() {
    
    self.rightItemStack.snp.makeConstraints{ horizontalStack in
      horizontalStack.centerY.equalToSuperview()
      horizontalStack.trailing.equalToSuperview().offset(24)
    }
    
    self.backButton.snp.makeConstraints { backButton in
      backButton.centerY.equalToSuperview()
      backButton.leading.equalToSuperview().offset(24)
    }
  }
  
  public func setTitleText(_ text: String?) {
    self.addSubview(self.titleLabel)
    
    self.titleLabel.text = text
    self.titleLabel.snp.makeConstraints { make in
      make.centerY.centerX.equalToSuperview()
    }
  }
  
  public func addRightButton(_ button: UIButton) {
    self.rightItemStack.addArrangedSubview(button)
  }
  
  public func setBackButton() {
    self.addSubview(self.backButton)
    
    backButton.snp.makeConstraints{ backButton in
      backButton.centerY.equalToSuperview()
      backButton.leading.equalToSuperview().offset(24)
      backButton.height.width.equalTo(24)
    }
  }
}
