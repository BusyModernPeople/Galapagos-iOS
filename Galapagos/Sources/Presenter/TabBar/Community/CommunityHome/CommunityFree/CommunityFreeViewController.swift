//
//  CommunityFreeViewController.swift
//  Galapagos
//
//  Created by Siri on 2023/10/20.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import RxCocoa
import RxSwift

import SiriUIKit
import SnapKit

import UIKit

final class CommunityFreeViewController: BaseViewController {
	
	// MARK: - UI
	
	
	// MARK: - Properties
	private let viewModel: CommunityFreeViewModel
	
	// MARK: - Initializers
	
	init(
		viewModel: CommunityFreeViewModel
	) {
		self.viewModel = viewModel
		super.init()
	}
	
	// MARK: - LifeCycle
	
	// MARK: - Methods
	
	override func setAddSubView() {
		
	}
	
	override func setConstraint() {
		
	}
	
	override func bind() {
		
	}
}
