//
//  CommunityQnACoordinator.swift
//  Galapagos
//
//  Created by Siri on 2023/10/20.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import RxRelay
import RxSwift

import UIKit

class CommunityQnACoordinator: Coordinator {
	var navigationController: UINavigationController
	
	var delegate: CoordinatorDelegate?
	var childCoordinators: [Coordinator] = []
	var disposeBag: DisposeBag = DisposeBag()
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func setState() {}
	
	func start() {
		pushToCommunityQnA()
	}
	
	func pushToCommunityQnA() {
		let communityQnAViewController = CommunityQnAViewController(
			viewModel: CommunityQnAViewModel(
				coordinator: self
				// usecase 추가
			)
		)
		self.pushViewController(viewController: communityQnAViewController)
	}
}
