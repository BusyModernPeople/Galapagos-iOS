//
//  GalapagosIndecatorManager.swift
//  Galapagos
//
//  Created by Siri on 2023/10/20.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import RxCocoa
import RxSwift

import UIKit

class GalapagosIndecatorManager {
	
	// MARK: - UI Components
	private var backgroundView: UIView?
	
	// MARK: - Properties
	
	static let shared = GalapagosIndecatorManager()
	
	private let disposeBag = DisposeBag()
	private let visibilityRelay = PublishRelay<Bool>()
	private weak var window: UIWindow?
	
	// MARK: - Initializer
	
	private init() {
		setup()
	}
	
	// MARK: - Methods
	func setup() {
		
		let scenes = UIApplication.shared.connectedScenes
		let windowScene = scenes.first as? UIWindowScene
		let window = windowScene?.windows.first
		
		self.window = window
		
		visibilityRelay
			.observe(on: MainScheduler.instance)
			.withUnretained(self)
			.subscribe(onNext: { owner, isVisible in
				if isVisible {
					owner.createAndShowIndicator()
				} else {
					owner.removeAndHideIndicator()
				}
			})
			.disposed(by: disposeBag)
	}
	
	
	private func createAndShowIndicator() {
		if backgroundView == nil {
			backgroundView = UIView()
			backgroundView?.backgroundColor = GalapagosAsset.blackDisplayHeadingBody.color.withAlphaComponent(0.4)
		}
		
		let indicatorView: UIActivityIndicatorView = {
			let indicator = UIActivityIndicatorView(style: .large)
			indicator.color = .gray
			return indicator
		}()
		
		backgroundView?.frame = UIScreen.main.bounds
		indicatorView.center = backgroundView!.center
		backgroundView?.addSubview(indicatorView)
		window?.addSubview(backgroundView!)
		
		indicatorView.startAnimating()
	}
	
	private func removeAndHideIndicator() {
		backgroundView?.removeFromSuperview()
		backgroundView = nil
	}
	
	func show() {
		visibilityRelay.accept(true)
	}
	
	func hide() {
		visibilityRelay.accept(false)
	}
	
}
