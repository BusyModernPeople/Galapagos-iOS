//
//  TabBarCoordinator.swift
//  Galapagos
//
//  Created by 조용인 on 2023/05/26.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit

import RxRelay
import RxSwift


final class TabBarCoordinator: Coordinator {
  
  // MARK: - Coordinator DEPTH 1 -
  
  // MARK: - Need To Initializing
  
  var navigationController: UINavigationController
  
  // MARK: - Don't Need To Initializing
  
  lazy var tabBarController = CustomTabBarController(coordinator: self)
  var userActionState: PublishRelay<TabBarCoordinatorFlow> = PublishRelay()
  var childCoordinators: [Coordinator] = []
  var disposeBag: DisposeBag = DisposeBag()
  var delegate: CoordinatorDelegate?
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.setState()
  }
  
  func setState() {
    self.userActionState
      .distinctUntilChanged() // 이전 상태와 동일한 상태는 무시
      .debug()
      .subscribe(onNext: { [weak self] state in
        print("💚💚💚 TabBarCoordinator: \(state) 💚💚💚")
        guard let self = self else {return}
        self.tabBarController.selectedIndex = state.rawValue
      }).disposed(by: disposeBag)
  }
  
  func start() {
    let pages: [TabBarCoordinatorFlow] = TabBarCoordinatorFlow.allCases
    let controllers: [UINavigationController] = pages.map { flow in
      self.createTabNavigationController(of: flow)
    }
    self.configureTabBarController(with: controllers)
    self.userActionState.accept(.main)
  }
  
  func detailDiary() {
    if let diaryListCoordinator = childCoordinators[1] as? DiaryListCoordinator {
      self.userActionState.accept(.diary)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
           diaryListCoordinator.userActionState.accept(.diaryDetail)
         }
    }
  }
}


// MARK: - Extension

private extension TabBarCoordinator {
  private func configureTabBarController(with tabViewControllers: [UIViewController]) {
    self.tabBarController.setViewControllers(tabViewControllers, animated: true)
    self.navigationController.setNavigationBarHidden(true, animated: false)
    self.navigationController.viewControllers = [tabBarController] //아예 새로 시작
//    self.navigationController.pushViewController(tabBarController, animated: true)//삭제
  }
  
  func createTabNavigationController(of page: TabBarCoordinatorFlow) -> UINavigationController {
    let navigationController = UINavigationController()
    navigationController.setNavigationBarHidden(true, animated: false)
    navigationController.tabBarItem = page.tabBarItem
    connectTabCoordinator(of: page, to: navigationController)
    return navigationController
  }
  
  func connectTabCoordinator(of page: TabBarCoordinatorFlow, to navigationController: UINavigationController) {
    switch page {
    case .main:
      let mainCoordinator = MainCoordinator(navigationController: navigationController, parentsCoordinator: self)
      mainCoordinator.delegate = self
      mainCoordinator.start()
      childCoordinators.append(mainCoordinator)
    case .diary:
      let diaryCoordinator = DiaryListCoordinator(navigationController: navigationController)
      diaryCoordinator.delegate = self
      diaryCoordinator.start()
      childCoordinators.append(diaryCoordinator)
    case .community:
      let communityCoordinator = CommunityListCoordinator(navigationController: navigationController)
      communityCoordinator.delegate = self
      communityCoordinator.start()
      childCoordinators.append(communityCoordinator)
    case .mypage:
      let mypageCoordinator = MyPageCoordinator(navigationController: navigationController)
      mypageCoordinator.delegate = self
      mypageCoordinator.start()
      childCoordinators.append(mypageCoordinator)
    }
  }
}


// MARK: - CoordinatorDelegate

extension TabBarCoordinator: CoordinatorDelegate {
  func didFinish(childCoordinator: Coordinator) {
    self.navigationController.popViewController(animated: true)
    self.finish()
  }
}

