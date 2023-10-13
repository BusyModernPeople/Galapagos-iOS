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
    case addAnimal, diary
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
        case .addAnimal:
          self.pushToAddAnimal()
          
        case .diary:
          self.pushToDiary(animalIdx: "임시")
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

extension DiaryListCoordinator: AddAnimalCoordinating {
  func pushToAddAnimal() {
    if let tabBarViewController = self.navigationController
      .tabBarController as? CustomTabBarController {
      tabBarViewController.hideCustomTabBar()
    }
    let addAnimalCoordinator = AddAnimalCoordinator(
      navigationController: self.navigationController
    )
    addAnimalCoordinator.delegate = self
    addAnimalCoordinator.start()
    self.childCoordinators.append(addAnimalCoordinator)
  }
}

extension DiaryListCoordinator: DiaryCoordinating {
  func pushToDiary(animalIdx: String) {
    if let tabBarViewController = self.navigationController
      .tabBarController as? CustomTabBarController {
      tabBarViewController.hideCustomTabBar()
    }
    let diaryCoordinator = DiaryCoordinator(
      animalIdx: animalIdx, navigationController: self.navigationController
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
