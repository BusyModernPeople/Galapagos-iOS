//
//  TabBarCoordinator.swift
//  Galapagos
//
//  Created by 조용인 on 2023/05/26.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//


import UIKit
import RxSwift
import RxRelay


class TabBarCoordinator: Coordinator {

    var navigationController: UINavigationController
    
    lazy var tabBarController = CustomTabBarController(coordinator: self)
    var userActionState: PublishRelay<TabBarCoordinatorFlow> = PublishRelay()
    var childCoordinators: [Coordinator] = []
    var disposeBag: DisposeBag = DisposeBag()
    var delegate: CoordinatorDelegate?
    
    init(
        navigationController: UINavigationController
    ){
        self.navigationController = navigationController
        self.setState()
    }
    
    func setState() {
        self.userActionState
            .debug()
            .subscribe(onNext: { [weak self] state in
                print("💚💚💚 TabBarCoordinator: \(state) 💚💚💚")
                guard let self = self else {return}
                tabBarController.selectedIndex = state.rawValue
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
}

//TabBar는 초기 설정 필요
private extension TabBarCoordinator {
    private func configureTabBarController(with tabViewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(tabViewControllers, animated: true)
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(tabBarController, animated: true)
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
            let diaryCoordinator = DiaryCoordinator(navigationController: navigationController)
            diaryCoordinator.delegate = self
            diaryCoordinator.start()
            childCoordinators.append(diaryCoordinator)
        case .community:
            let communityCoordinator = CommunityCoordinator(navigationController: navigationController)
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

extension TabBarCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        self.navigationController.popViewController(animated: true)
        self.finish()
    }
}

