//
//  CustomTabBarController.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/06/11.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import RxRelay
import RxSwift
import UIKit

final class CustomTabBarController: UITabBarController {
  
  // MARK: - Properties
  
  let selectedItemSubject = PublishRelay<Int>()
  
  weak var coordinator: TabBarCoordinator?
  let customTabBar = CustomTabBar()
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  init(coordinator: TabBarCoordinator) {
    super.init(nibName: nil, bundle: nil)
    self.delegate = self
    self.coordinator = coordinator
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setAddSubView()
    setConstraint()
    bind()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.showCustomTabBar()
  }
  
  private func setAddSubView() {
    self.view.addSubview(customTabBar)
  }
  
  private func setAttribute() {
    customTabBar.setShadow()
  }
  
  private func setConstraint() {
    customTabBar.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.11)
    }
  }
  
  // MARK: - Binding
  private func bind() {
    customTabBar
      .itemTapped // Input, 터치가 감지되면 Coordinator에 상태 변경 요청, 발행자는 View
      .bind { [weak self] in
        self?
          .coordinator?
          .userActionState
          .accept(
            TabBarCoordinatorFlow(rawValue: $0) ?? .main
          )
      }
      .disposed(by: disposeBag)
    
    selectedItemSubject // Output, Coordinator의 상태 변경 감지되면 UI 변경 View에게 전달, 빌헹자는 Coordinator
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] index in
        guard let self = self else {return}
        self.customTabBar
          .changeImage(index: index)
      })
      .disposed(by: disposeBag)
  }
}

// MARK: - Extension
extension CustomTabBarController {
  func hideCustomTabBar() {
    self.tabBar.isHidden = true
    customTabBar.isHidden = true
  }
  
  func showCustomTabBar() {
    self.tabBar.isHidden = true
    customTabBar.isHidden = false
  }
}

// MARK: - Extension UITabBarControllerDelegate
extension CustomTabBarController: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    return false
  }
}
