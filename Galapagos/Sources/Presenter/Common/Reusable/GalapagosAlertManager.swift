//
//  GalapagosAlertManager.swift
//  Galapagos
//
//  Created by Siri on 2023/10/20.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import RxSwift

import SiriUIKit
import UIKit

class GalapagosAlertManager {
	
	static let shared = GalapagosAlertManager()
	
	private let disposeBag: DisposeBag = DisposeBag()
	
	private init() {
		
	}
	
	func alertResponse(title: String, body: String?, cancelTitle: String, actionTitle: String) -> Observable<Bool> {
		return Observable.create { observer in
			let alertActionObservable = self.showAlert(
				title: title,
				body: body,
				cancelTitle: cancelTitle,
				actionTitle: actionTitle
			)
			let subscription = alertActionObservable.subscribe { didConfirm in
				observer.onNext(didConfirm)
				observer.onCompleted()
			}
			return Disposables.create {
				subscription.dispose()
			}
		}
	}
	
	private func showAlert(
		title: String,
		body: String?,
		cancelTitle: String,
		actionTitle: String
	) -> PublishSubject<Bool> {
		
		let alertActionSubject = PublishSubject<Bool>()
		
		let backgroundView: UIView = {
			let view = UIView()
			view.backgroundColor = GalapagosAsset.blackDisplayHeadingBody.color.withAlphaComponent(0.4)
			return view
		}()
		
		let newAlert = GalapagosAlert(
			title: title,
			body: body,
			cancelTitle: cancelTitle,
			actionTitle: actionTitle
		)
		
		if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
			if let window = windowScene.windows.first {
				window.addSubview(backgroundView)
				backgroundView.addSubview(newAlert)
				
				backgroundView.snp.makeConstraints { make in
					make.edges.equalToSuperview()
				}
				
				newAlert.snp.makeConstraints { make in
					make.center.equalToSuperview()
					make.width.equalTo(272)
					make.height.equalTo(184)
				}
				
			}
		}
		
		backgroundView.fadeIn()
		
		
		newAlert.alertAction
			.subscribe(onNext: { didConfirm in
				backgroundView.fadeOut(completion: { _ in backgroundView.removeFromSuperview() })
				alertActionSubject.onNext(didConfirm)
				alertActionSubject.onCompleted()
			})
			.disposed(by: disposeBag)
		
		return alertActionSubject
	}
	
	
}

extension UIView {
	fileprivate func fadeIn(duration: TimeInterval = 0.3) {
		self.alpha = 0.0
		UIView.animate(withDuration: duration) {
			self.alpha = 1.0
		}
	}
	
	fileprivate func fadeOut(duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
		UIView.animate(withDuration: duration, animations: {
			self.alpha = 0.0
		}, completion: completion)
	}
}


//MARK: - 아래는 테스트 코드입니다. (사용 예시)
/// `SceneDelegate.swift`의 `scene(_ scene:willConnectTo:options:)`에 아래 코드 사용해서 테스트 가능
/*
 let test = AlertTestViewController()
 
 window?.rootViewController = test
 window?.makeKeyAndVisible()
 */

/// 아래의 `AlertTestViewController`를 활성화 하여 사용
/*
 
 import RxCocoa
 import RxSwift

 import UIKit

 class AlertTestViewController: UIViewController {
	 
	 private let showButton: UIButton = {
		 let button = UIButton(type: .system)
		 button.setTitle("얼럿 띄우기", for: .normal)
		 return button
	 }()
	 
	 private let disposeBag = DisposeBag()
	 
	 private let alertRelay = PublishRelay<Bool>()
	 
	 override func viewDidLoad() {
		 super.viewDidLoad()
		 
		 setupUI()
		 
		 showButton.rx.tap
			 .flatMapLatest { _ -> Observable<Bool> in
				 let alertManager = GalapagosAlertManager.shared
				 return alertManager.alertResponse(
					 title: "메인 타이틀12312312321312312313",
					 body: "여기는 Optional입니다.(nil 처리 가능)",
					 cancelTitle: "취소",
					 actionTitle: "확인"
				 )
			 }
			 .bind(to: alertRelay)
			 .disposed(by: disposeBag)
		 
		 alertRelay
			 .subscribe(onNext: { didConfirm in
				 print("이 곳에서 얼럿의 상태 처리: \(didConfirm)")
			 })
			 .disposed(by: disposeBag)
	 }
	 
	 private func setupUI() {
		 
		 self.view.backgroundColor = .white
		 view.addSubview(showButton)
		 
		 showButton.translatesAutoresizingMaskIntoConstraints = false
		 NSLayoutConstraint.activate([
			 showButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			 showButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		 ])
	 }
 }

 */
