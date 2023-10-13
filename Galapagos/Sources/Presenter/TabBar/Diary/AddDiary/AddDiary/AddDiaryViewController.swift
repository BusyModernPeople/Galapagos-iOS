//
//  AddDiaryViewController.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/06/20.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import RxCocoa
import RxSwift
import SiriUIKit
import SnapKit
import UIKit

class AddDiaryViewController: BaseViewController {
  
  // MARK: - UI
  private lazy var mockLabel: UILabel = {
    let label = UILabel()
    label.text = "AddDiary"
    label.textColor = GalapagosAsset.green.color
    label.font = GalapagosFontFamily.Pretendard.bold.font(size: 36)
    return label
  }()
  
  private lazy var navigationBar: GalapagosNavigationBarView = {
    let navigationBar = GalapagosNavigationBarView()
    navigationBar.setTitleText("")
    return navigationBar
  }()
  
  // MARK: - Properties
  private let viewModel: AddDiaryViewModel
  
  // MARK: - Initializers
  init(
    viewModel: AddDiaryViewModel
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
  }
  
  override func setAddSubView() {
    self.view.addSubviews([
      navigationBar,
      mockLabel
    ])
  }
  
  override func bind() {
    let input = AddDiaryViewModel.Input(
      backButtonTapped: navigationBar.backButton.rx.tap.asSignal()
    )
    
    _ = viewModel.transform(input: input)
  }
}
