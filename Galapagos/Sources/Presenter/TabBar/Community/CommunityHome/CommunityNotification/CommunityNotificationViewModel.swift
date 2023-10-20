//
//  CommunityNotificationViewModel.swift
//  Galapagos
//
//  Created by Siri on 2023/10/20.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

final class CommunityNotificationViewModel: ViewModelType {
	struct Input {
		
	}
	
	struct Output {
		
	}
	
	var disposeBag: DisposeBag = DisposeBag()
	weak var coordinator: CommunityNotificationCoordinator?
	
	init(coordinator: CommunityNotificationCoordinator) {
		self.coordinator = coordinator
	}
	
	func transform(input: Input) -> Output {
		
		return Output()
	}
}
