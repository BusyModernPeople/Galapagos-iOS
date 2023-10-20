//
//  UIViewController+.swift
//  Galapagos
//
//  Created by 조용인 on 2023/05/23.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit

extension UIViewController {
  
  var navigationBarToContentsOffset: CGFloat {
    return 16 // 비율로 변경 예정
  }
  
  var contentsToContentsOffset: CGFloat {
    return 48 //
  }
  
  var galpagosHorizontalOffset: CGFloat {
    return UIScreen.main.bounds.width / 16.25 // 좌우 간격
  }
  
  // MARK: 빈 화면을 눌렀을 때 키보드가 내려가도록 처리
  func dismissKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer =
    UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    self.view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    self.view.endEditing(false)
  }
  
  // MARK: UIWindow의 rootViewController를 변경하여 화면전환
  func changeRootViewController(_ viewControllerToPresent: UIViewController) {
    let scenes = UIApplication.shared.connectedScenes
    let windowScene = scenes.first as? UIWindowScene
    
    if let window = windowScene?.windows.first {
      window.rootViewController = viewControllerToPresent
      UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
    } else {
      viewControllerToPresent.modalPresentationStyle = .overFullScreen
      self.present(viewControllerToPresent, animated: true, completion: nil)
    }
  }
  
  static func loadFromNib() -> Self {
    func instantiateFromNib<T: UIViewController>() -> T {
      return T.init(nibName: String(describing: T.self), bundle: nil)
    }
    
    return instantiateFromNib()
  }
}
