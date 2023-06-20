//
//  DiaryCoordinator.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/06/11.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit

import RxSwift
import RxRelay

class DiaryListCoordinator: Coordinator {
  
  enum DiaryListCoordinatorFlow {
    case addPet, diaryDetail
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
        print("💗💗💗 DiaryCoordinator: \(state) 💗💗💗")
        guard let self = self else { return }
        switch state {
        case .addPet:
          self.pushToAddPet()
          
        case .diaryDetail:
          self.pushToDetailDiary(petIdx: "임시")
        }
      }).disposed(by: disposeBag)
  }
  
  func start() {
    self.navigationController.tabBarController?.tabBar.isHidden = false
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
    self.navigationController.tabBarController?.tabBar.isHidden = true
    let addPetCoordinator = AddPetCoordinator(
      navigationController: self.navigationController
    )
    addPetCoordinator.delegate = self
    addPetCoordinator.start()
    self.childCoordinators.append(addPetCoordinator)
  }
}

extension DiaryListCoordinator: DetailDiaryCoordinating {
  func pushToDetailDiary(petIdx: String) {
    self.navigationController.tabBarController?.tabBar.isHidden = true
    let diaryDetailCoordinator = DetailDiaryCoordinator(
      petIdx: petIdx, navigationController: self.navigationController
    )
    diaryDetailCoordinator.delegate = self
    diaryDetailCoordinator.start()
    self.childCoordinators.append(diaryDetailCoordinator)
  }
}

extension DiaryListCoordinator: CoordinatorDelegate {
  func didFinish(childCoordinator: Coordinator) {
    self.navigationController.tabBarController?.tabBar.isHidden = false
    self.popViewController()
  }
}
