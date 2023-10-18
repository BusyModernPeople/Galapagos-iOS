//
//  MainCoordinator.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/06/11.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import RxRelay
import RxSwift
import UIKit


final class MainCoordinator: Coordinator {
  
  // MARK: - Coordinator DEPTH 2 -
  
  enum MainCoordinatorFlow {
    case addAnimal
    case mainAnimalDiary
    case moveCommunity
    case detailPost // 초기화면 삭제
  }
  
  var navigationController: UINavigationController
  var parentsCoordinator: TabBarCoordinator
  
  // MARK: - Don't Need To Initializing
  
  var userActionState: PublishRelay<MainCoordinatorFlow> = PublishRelay()
  var childCoordinators: [Coordinator] = []
  var disposeBag: DisposeBag = DisposeBag()
  var delegate: CoordinatorDelegate?
  
  init(
    navigationController: UINavigationController,
    parentsCoordinator: TabBarCoordinator
  ) {
    self.navigationController = navigationController
    self.parentsCoordinator = parentsCoordinator
    self.setState()
  }
  
  func setState(){
    self.userActionState
      .debug()
      .subscribe(onNext: { [weak self] state in
        print("💗💗💗 MainCoordinator: \(state) 💗💗💗")
        guard let self = self else { return }
        switch state {
        case .addAnimal:
          self.pushToAddAnimal()
          
        case .mainAnimalDiary:
          self.pushToDiary(animalIdx: "임시") // Idx 가져 올 방법 고민 (enum 유력)
          
        case .moveCommunity:
          self.moveToCommunityTab()
        case .detailPost:
          break
        }
      }).disposed(by: disposeBag)
  }
  
  func start() {
    print("🔥MainCoordinator start 메서드")
    let mainViewController = MainViewController(
      viewModel: MainViewModel(
        coordinator: self
      )
    )
    print("MainCoordinator mainViewController 생성 완료")
    self.pushViewController(viewController: mainViewController)
  }
}

extension MainCoordinator: AddAnimalCoordinating {
  func pushToAddAnimal() {
    if let tabBarViewController = self.navigationController.tabBarController as? CustomTabBarController {
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

extension MainCoordinator: DiaryCoordinating {
  func pushToDiary(animalIdx: String) {
    if let tabBarViewController = self.navigationController
      .tabBarController as? CustomTabBarController {
      tabBarViewController.hideCustomTabBar()
    }
    let diaryCoordinator = DiaryCoordinator(
      animalIdx: "임시",
      navigationController: self.navigationController
    )
    diaryCoordinator.delegate = self
    diaryCoordinator.start()
    self.childCoordinators.append(diaryCoordinator)
  }
}

extension MainCoordinator { // 이 기능만 유일하게 Coordinator가 finsh가 아닌 사유로 부모 Coordinator 접근
  func moveToCommunityTab() {
    self.parentsCoordinator.userActionState.accept(.community)
  }
}

//extension MainCoordinator: DetailPostCoordinating {
//  func pushToDetailPost(postIdx: String) {
//    //
//  }
//}

extension MainCoordinator: CoordinatorDelegate {
  func didFinish(childCoordinator: Coordinator) { // 복귀 시 탭바 재생성
    if let tabBarViewController = self.navigationController.tabBarController as? CustomTabBarController {
      tabBarViewController.showCustomTabBar()
    }
    self.popViewController()
  }
}
