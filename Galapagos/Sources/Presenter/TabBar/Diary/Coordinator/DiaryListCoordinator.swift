//
//  DiaryCoordinator.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/06/11.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import RxRelay
import RxSwift
import UIKit

class DiaryListCoordinator: Coordinator {
  
  enum DiaryListCoordinatorFlow {
    case addPet, diary
  }
  
  var disposeBag: DisposeBag = DisposeBag()
  
  var navigationController: UINavigationController
  var userActionState: PublishRelay<DiaryListCoordinatorFlow> = PublishRelay()
  var childCoordinators: [Coordinator] = []
  var delegate: CoordinatorDelegate?
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.setState()
  }
  
  func setState() {
    self.userActionState
      .debug()
      .subscribe(onNext: { [weak self] state in
        print("💗💗💗 DiaryListCoordinator: \(state) 💗💗💗")
        guard let self = self else { return }
        switch state {
        case .addPet:
          self.pushToAddPet()
          
        case .diary:
          self.pushToDiary(petIdx: "임시")
        }
      }).disposed(by: disposeBag)
  }
  
  func start() {
    if let tabBarViewController = self.navigationController
      .tabBarController as? CustomTabBarController {
      tabBarViewController.hideCustomTabBar()
    }
    let diaryListViewController = DiaryListViewController(
      viewModel: DiaryListViewModel(
        coordinator: self
      )
    )
    self.pushViewController(viewController: diaryListViewController)
  }
}

extension DiaryListCoordinator: AddPetCoordinating {
  func pushToAddPet() {
    if let tabBarViewController = self.navigationController
      .tabBarController as? CustomTabBarController {
      tabBarViewController.hideCustomTabBar()
    }
    let addPetCoordinator = AddPetCoordinator(
      navigationController: self.navigationController
    )
    addPetCoordinator.delegate = self
    addPetCoordinator.start()
    self.childCoordinators.append(addPetCoordinator)
  }
}

extension DiaryListCoordinator: DiaryCoordinating {
  func pushToDiary(petIdx: String) {
    if let tabBarViewController = self.navigationController
      .tabBarController as? CustomTabBarController {
      tabBarViewController.hideCustomTabBar()
    }
    let diaryCoordinator = DiaryCoordinator(
      petIdx: petIdx, navigationController: self.navigationController
    )
    diaryCoordinator.delegate = self
    diaryCoordinator.start()
    self.childCoordinators.append(diaryCoordinator)
  }
}

extension DiaryListCoordinator: CoordinatorDelegate {
  func didFinish(childCoordinator: Coordinator) {
    if let tabBarViewController = self.navigationController
      .tabBarController as? CustomTabBarController {
      tabBarViewController.showCustomTabBar()
    }
    self.popViewController()
  }
}
