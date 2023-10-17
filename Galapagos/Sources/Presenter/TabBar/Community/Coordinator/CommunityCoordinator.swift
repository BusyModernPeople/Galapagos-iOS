//
//  CommunityCoordinator.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/06/11.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import RxRelay
import RxSwift
import UIKit

class CommunityCoordinator: Coordinator {
  
  // MARK: - Coordinator DEPTH 2 -
	
	enum CommunityCoordinatorFlow {
		case free
		case qna
		case notification
	}
	
  // MARK: - Need To Initializing
    
  var navigationController: UINavigationController
  
  // MARK: - Don't Need To Initializing
    
	var userActionState: PublishRelay<CommunityCoordinatorFlow> = PublishRelay()
  var childCoordinators: [Coordinator] = []
  var disposeBag: DisposeBag = DisposeBag()
  var delegate: CoordinatorDelegate?
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func setState() {
    //
  }
  
  func start() {
		print("🔥CommunityCoordinator start 메서드")
		let communityViewController = CommunityViewController(
			viewModel: CommunityViewModel(
				coordinator: self
			)
		)
		self.pushViewController(viewController: communityViewController)
	}
}

extension CommunityCoordinator: CoordinatorDelegate {
	func didFinish(childCoordinator: Coordinator) { // 복귀 시 탭바 재생성
		if let tabBarViewController = self.navigationController.tabBarController as? CustomTabBarController {
			tabBarViewController.showCustomTabBar()
		}
		self.popViewController()
	}
}
