//
//  DiaryViewController.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/06/17.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import RxCocoa
import RxSwift
import SiriUIKit
import SnapKit
import UIKit

class DiaryViewController: BaseViewController {
  
  // MARK: - UI
  private lazy var mockLabel: UILabel = {
    let label = UILabel()
    label.text = "DiaryView"
    label.textColor = GalapagosAsset.green.color
    label.font = GalapagosFontFamily.Pretendard.bold.font(size: 36)
    return label
  }()
  
  private var button = UIButton().then {
    $0.backgroundColor = .darkGray
    $0.setTitle("add", for: .normal)
  }
  
  private lazy var navigationBar: GalapagosNavigationBarView = {
    let navigationBar = GalapagosNavigationBarView()
    navigationBar.setTitleText("")
    return navigationBar
  }()
  
  // MARK: - Properties
  private let viewModel: DiaryViewModel
  
  // MARK: - Initializers
  init(
    viewModel: DiaryViewModel
  ) {
    self.viewModel = viewModel
    super.init()
  }
  
  // MARK: - LifeCycle
  
  // MARK: - Methods
  
  override func setConstraint() {
    navigationBar.snp.makeConstraints{ navigationBar in
      navigationBar.top.equalTo(self.view.safeAreaLayoutGuide)
      navigationBar.leading.trailing.equalToSuperview()
      navigationBar.height.equalTo(50)
    }
    
    mockLabel.snp.makeConstraints{ mockLabel in
      mockLabel.centerX.equalToSuperview()
      mockLabel.centerY.equalToSuperview()
    }
    
    button.snp.makeConstraints { button in
      button.trailing.equalToSuperview().inset(16)
      button.bottom.equalToSuperview().inset(16)
      button.width.equalTo(50)
      button.height.equalTo(50)
    }
  }
  
  override func setAddSubView() {
    self.view.addSubviews([
      navigationBar,
      mockLabel,
      button
    ])
  }
  
  override func bind() {
    let input = DiaryViewModel.Input(
      backButtonTapped: navigationBar.backButton.rx.tap.asSignal(),
      buttonTapped: button.rx.tap.asSignal()
    )
    
    _ = viewModel.transform(input: input)
  }
}
