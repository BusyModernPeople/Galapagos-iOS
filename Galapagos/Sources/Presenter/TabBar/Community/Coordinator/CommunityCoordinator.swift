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

protocol CommunityCoordinatorProtocol {
	func pushToFree()
	func pushToQnA()
	func pushToNotification()
}

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
		self.userActionState
			.withUnretained(self)
			.subscribe(onNext: { owner, state in
				print("💗💗💗 CommunityCoordinator: \(state) 💗💗💗")
				switch state {
				case .free:
					owner.pushToFree()
				case .qna:
					owner.pushToQnA()
				case .notification:
					owner.pushToNotification()
				}
			}).disposed(by: disposeBag)
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

// MARK: - Community's Push
extension CommunityCoordinator: CommunityCoordinatorProtocol {
	func pushToFree() {
		if let tabBarViewController = self.navigationController
			.tabBarController as? CustomTabBarController {
			tabBarViewController.hideCustomTabBar()
		}
		let communityFreeCoordinator = CommunityFreeCoordinator(
			navigationController: self.navigationController
		)
		communityFreeCoordinator.delegate = self
		communityFreeCoordinator.start()
		self.childCoordinators.append(communityFreeCoordinator)
	}
	
	func pushToQnA() {
		if let tabBarViewController = self.navigationController
			.tabBarController as? CustomTabBarController {
			tabBarViewController.hideCustomTabBar()
		}
		let communityQnACoordinator = CommunityQnACoordinator(
			navigationController: self.navigationController
		)
		communityQnACoordinator.delegate = self
		communityQnACoordinator.start()
		self.childCoordinators.append(communityQnACoordinator)
	}
	
	func pushToNotification() {
		if let tabBarViewController = self.navigationController
			.tabBarController as? CustomTabBarController {
			tabBarViewController.hideCustomTabBar()
		}
		let communityNotificationCoordinator = CommunityNotificationCoordinator(
			navigationController: self.navigationController
		)
		communityNotificationCoordinator.delegate = self
		communityNotificationCoordinator.start()
		self.childCoordinators.append(communityNotificationCoordinator)
	}
	
	
}

extension CommunityCoordinator: CoordinatorDelegate {
	func didFinish(childCoordinator: Coordinator) {
		if let tabBarViewController = self.navigationController.tabBarController as? CustomTabBarController {
			tabBarViewController.showCustomTabBar()
		}
		self.popViewController()
	}
}
