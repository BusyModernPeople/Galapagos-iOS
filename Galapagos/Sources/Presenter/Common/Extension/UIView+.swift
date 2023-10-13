//
//  UIView+.swift
//  Galapagos
//
//  Created by 조용인 on 2023/05/23.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {
	
	var navigationBarToContentsOffset: CGFloat {
		return 40 // 세로도 화면 비율로 가져가는 게 좋을지
	}
	
	var contentsToContentsOffset: CGFloat {
		return 60 // 세로도 화면 비율로 가져가는 게 좋을지
	}
	
	var galpagosHorizontalOffset: CGFloat {
		return UIScreen.main.bounds.width / 16.25 // 좌우 간격
	}
	
	@IBInspectable var cornerRadius: CGFloat {
		get { return self.layer.cornerRadius }
		set {
			self.clipsToBounds = true
			self.layer.cornerRadius = newValue
		}
	}
	
	@IBInspectable var borderWidth: CGFloat {
		get { return self.layer.borderWidth }
		set { self.layer.borderWidth = newValue }
	}
	
	@IBInspectable var borderColor: UIColor? {
		get { return (self.layer.borderColor != nil) ? UIColor(cgColor: self.layer.borderColor!) : nil }
		set { self.layer.borderColor = newValue?.cgColor }
	}
	
	func initShadow(x: CGFloat, y: CGFloat, blur: CGFloat, spread: CGFloat, color: UIColor, alpha: Float) {
		self.layer.masksToBounds = false
		self.layer.shadowColor = color.cgColor
		self.layer.shadowOpacity = alpha
		self.layer.shadowOffset = CGSize(width: x, height: y)
		self.layer.shadowRadius = blur / 2.0
		if spread == 0 {
			self.layer.shadowPath = nil
		} else {
			let dx = -spread
			let rect = self.layer.bounds.insetBy(dx: dx, dy: dx)
			self.layer.shadowPath = UIBezierPath(rect: rect).cgPath
		}
	}
	
	func addSubviews(_ subviews: [UIView]) {
		subviews.forEach(self.addSubview)
	}
	
	func animateClick(completion: @escaping () -> Void) {
		UIView.animate(withDuration: 0.03) {
			self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
		} completion: { _ in
			UIView.animate(withDuration: 0.03) {
				self.transform = CGAffineTransform.identity
			} completion: { _ in
				completion()
			}
		}
	}
}
