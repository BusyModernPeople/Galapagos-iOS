//
//  GalapagosToastManager.swift
//  Galapagos
//
//  Created by Siri on 2023/10/20.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import SnapKit

import UIKit

final class GalapagosToastManager {
	
	// MARK: - Properties
	static let shared = GalapagosToastManager()
	
	// MARK: - Initializers
	private init() {
		
	}
	
	// MARK: - Functions
	func addToast(message: String) {
		self.showToast(message: message)
	}
	
	private func showToast(message: String) {
		guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
		
		if let window = sceneDelegate.window {
			let toastView = ToastView(frame: window.bounds, message: message)
			
			window.addSubview(toastView)
			
			toastView.snp.makeConstraints { make in
				make.centerX.equalTo(window.snp.centerX)
				make.width.equalTo(260)
				make.bottom.equalTo(window.snp.bottom).offset(-122)
			}
			
			UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseInOut, animations: {
				toastView.alpha = 0
			}, completion: { isCompleted in
				toastView.removeFromSuperview()
			})
		}
	}
	
}


private class ToastView: UIView {
	let toastLabel = UILabel()
	
	init(
		frame: CGRect,
		message: String
	) {
		super.init(frame: frame)
		
		self.backgroundColor = GalapagosAsset.gray1Body.color
		self.alpha = 0.8
		self.clipsToBounds = true
		
		toastLabel.textColor = GalapagosAsset.whiteDefaultWhite.color
		toastLabel.font = GalapagosFontFamily.Pretendard.bold.font(size: 14)
		toastLabel.textAlignment = .center
		toastLabel.text = message
		toastLabel.numberOfLines = 0
		toastLabel.sizeToFit()
		toastLabel.clipsToBounds = true
		
		self.addSubview(toastLabel)
		
		self.setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupConstraints() {
		toastLabel.snp.makeConstraints { make in
			make.top.equalTo(self.snp.top).offset(14)
			make.bottom.equalTo(self.snp.bottom).offset(-14)
			make.leading.equalTo(self.snp.leading).offset(40)
			make.trailing.equalTo(self.snp.trailing).offset(-40)
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.layer.cornerRadius = self.frame.height / 2
	}
	
}
