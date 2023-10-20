//
//  CommunityViewModel.swift
//  Galapagos
//
//  Created by Siri on 2023/10/17.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import UIKit


final class CommunityViewModel: ViewModelType {
	
	struct Input {
		
	}
	
	struct Output {
		
	}
	
	// MARK: - Properties
	var disposeBag: DisposeBag = DisposeBag()
	weak var coordinator: CommunityCoordinator?
	
	// MARK: - Initializers
	init(coordinator: CommunityCoordinator) {
		self.coordinator = coordinator
	}
	
	// MARK: - Methods
	func transform(input: Input) -> Output {
		return Output()
	}
	
}
