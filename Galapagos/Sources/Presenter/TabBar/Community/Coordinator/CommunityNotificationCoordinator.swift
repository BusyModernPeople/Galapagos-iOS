//
//  CommunityNotificationCoordinator.swift
//  Galapagos
//
//  Created by Siri on 2023/10/20.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import RxRelay
import RxSwift

import UIKit

class CommunityNotificationCoordinator: Coordinator {
	var navigationController: UINavigationController

	var delegate: CoordinatorDelegate?
	var childCoordinators: [Coordinator] = []
	var disposeBag: DisposeBag = DisposeBag()

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func setState() {}

	func start() {
		pushToCommunityNotification()
	}
	
	func pushToCommunityNotification() {
		let communityNotificationViewController = CommunityNotificationViewController(
			viewModel: CommunityNotificationViewModel(
				coordinator: self
				// usecase 추가
			)
		)
		self.pushViewController(viewController: communityNotificationViewController)
	}
}
