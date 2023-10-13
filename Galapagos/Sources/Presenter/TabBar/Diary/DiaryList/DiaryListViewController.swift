//
//  DiaryListViewController.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/06/11.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit

import SiriUIKit

class DiaryListViewController: BaseViewController {
  
  // MARK: - UI
  
  private lazy var navigationBar: GalapagosNavigationTabBarView = {
    let navigationBar = GalapagosNavigationTabBarView()
    navigationBar.setPageType(.diary)
    return navigationBar
  }()
  
  private var button = UIButton().then {
    $0.backgroundColor = .darkGray
    $0.setTitle("상세 다이어리", for: .normal)
  }
  
  private var button2 = UIButton().then {
    $0.backgroundColor = .blue
    $0.setTitle("펫 추가", for: .normal)
  }
  
  // MARK: - Properties
  
  private let viewModel: DiaryListViewModel
  
  // MARK: - Initializers
  
  init(viewModel: DiaryListViewModel) {
    self.viewModel = viewModel
    super.init()
  }
  
  // MARK: - Methods
  
  override func setAddSubView() {
    self.view.addSubviews([
      navigationBar,
      button,
      button2
    ])
  }
  
  override func setConstraint() {
    navigationBar.snp.makeConstraints{ navigationBar in
      navigationBar.top.equalTo(self.view.safeAreaLayoutGuide)
      navigationBar.leading.trailing.equalToSuperview()
      navigationBar.height.equalTo(50)
    }
    
    button.snp.makeConstraints { make in
      make.width.equalTo(300)
      make.height.equalTo(40)
      make.center.equalToSuperview()
    }
    
    button2.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(button.snp.bottom)
        .offset(20)
    }
  }
  
  override func bind() {
    let input = DiaryListViewModel.Input(
      buttonTapped: button.rx.tap.asSignal(),
      button2Tapped: button2.rx.tap.asSignal()
    )
    _ = viewModel.transform(input: input)
  }
}
