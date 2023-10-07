//
//  UIButton+.swift
//  Galapagos
//
//  Created by 조용인 on 2023/05/23.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit

// MARK: UIButton 내에 Indicator 표시
extension UIButton {
    func showIndicator() {
        let indicator = UIActivityIndicatorView()
        let buttonHeight = self.bounds.size.height
        let buttonWidth = self.bounds.size.width
        indicator.center = CGPoint(x: buttonWidth / 2, y: buttonHeight / 2)
        self.addSubview(indicator)
        indicator.startAnimating()
    }
    
    func dismissIndicator() {
        for view in self.subviews {
            if let indicator = view as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
    
    func setUnderlineTitle(_ title: String, withUnderlineStyle underlineStyle: NSUnderlineStyle = .single, baselineOffset: NSNumber = 3, font: UIFont, color: UIColor) {
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: underlineStyle.rawValue,
            .baselineOffset : baselineOffset,
            .font: font,
            .foregroundColor: color
        ]
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: title.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
