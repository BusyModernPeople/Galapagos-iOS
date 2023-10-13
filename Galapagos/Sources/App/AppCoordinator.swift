//
//  AppCoordinator.swift
//  Galapagos
//
//  Created by 조용인 on 2023/05/24.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class AppCoordinator: Coordinator {    

  // MARK: - Navigation DEPTH 0 -
  enum AppCoordinatorChild{
    case auth
    case tabBar
  }
  
  // MARK: - Need To Initializing
  var disposeBag: DisposeBag
  var userActionState: PublishRelay<AppCoordinatorChild> = PublishRelay()
  /// init에서만 호출하고, stream을 유지하기위해 BehaviorSubject 사용
  var navigationController: UINavigationController
  
  // MARK: - Don't Need To Initializing
  var childCoordinators: [Coordinator] = []
  var delegate: CoordinatorDelegate?
  
  init(
    navigationController: UINavigationController
  ) {
    self.navigationController = navigationController
    self.disposeBag = DisposeBag()
    self.setState()
  }
  
  func setState(){
    self.userActionState
      .subscribe(onNext: { [weak self] state in
        guard let self = self else {return}
        switch state{
        case .auth:
          let authCoordinator = AuthCoordinator(
            navigationController: self.navigationController
          )
          authCoordinator.delegate = self
          authCoordinator.start()
          self.childCoordinators.append(authCoordinator)
        case .tabBar:
          let tabBarCoordinator = TabBarCoordinator(
            navigationController: self.navigationController
          )
          tabBarCoordinator.start()
        }
      }).disposed(by: disposeBag)
  }
  
  func start() {
    let splashViewController = SplashViewController(
      viewModel: SplashViewModel(
        /// 여기에 나중에는 useCase도 추가 되어야겠지
        coordinator: self
      )
    )
    self.pushViewController(viewController: splashViewController)
  }
}

extension AppCoordinator: CoordinatorDelegate{
  func didFinish(childCoordinator: Coordinator) {
    self.navigationController.popViewController(animated: true)
    self.finish()
  }
}
