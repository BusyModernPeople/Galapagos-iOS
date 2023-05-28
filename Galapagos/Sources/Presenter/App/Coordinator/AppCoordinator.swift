//
//  AppCoordinator.swift
//  Galapagos
//
//  Created by 조용인 on 2023/05/24.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AppCoordinator: Coordinator {    
    //MARK: - Navigation DEPTH 0 -
    enum AppCoordinatorChild{
        case Auth, TabBar
    }
    
    //MARK: - Need To Initializing
    var disposeBag: DisposeBag
    var userActionState: BehaviorSubject<AppCoordinatorChild>/// init에서만 호출하고, stream을 유지하기위해 BehaviorSubject 사용
    var navigationController: UINavigationController
    
    //MARK: - Don't Need To Initializing
    var childCoordinators: [Coordinator] = []
    var delegate: CoordinatorDelegate?
    
    init(
        navigationController: UINavigationController,
        userActionState: AppCoordinatorChild
    ) {
        self.navigationController = navigationController
        self.userActionState = BehaviorSubject(value: userActionState)
        self.disposeBag = DisposeBag()
        
        self.setState()
    }
    
    func setState(){
        self.userActionState.subscribe(onNext: { [weak self] state in
            guard let self = self else {return}
            switch state{
            case .Auth:
                let authCoordinator = AuthCoordinator(
                    navigationController: self.navigationController,
                    userActionState: .SignIn
                )
                authCoordinator.delegate = self
                authCoordinator.start()
                self.childCoordinators.append(authCoordinator)
            case .TabBar:
                let tabBarCoordinator = TabBarCoordinator(
                    navigationController: self.navigationController,
                    userActionState: .Main
                )
                tabBarCoordinator.delegate = self
                tabBarCoordinator.start()
                self.childCoordinators.append(tabBarCoordinator)
            }
        }).disposed(by: disposeBag)
    }
    
    func start() {
        let splashViewController = SplashViewController(
            viewModel: SplashViewModel(
                /// 여기에 나중에는 useCase도 추가 되어야겠지
                coordinator: self
            )
        ) /// 나중에, viewModel, useCase등등 추가적인 의존성 주입 필요함
        self.pushViewController(viewController: splashViewController)
    }
}

extension AppCoordinator: CoordinatorDelegate{
    func didFinish(childCoordinator: Coordinator) {
        childCoordinator.finish()
    }
}
