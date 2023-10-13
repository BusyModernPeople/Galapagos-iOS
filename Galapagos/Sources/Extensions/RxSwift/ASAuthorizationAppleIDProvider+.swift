//
//  ASAuthorizationAppleIDProvider+.swift
//  Galapagos
//
//  Created by Siri on 2023/10/04.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import AuthenticationServices
import RxCocoa
import RxSwift


class ASAuthProxy: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>, DelegateProxyType {
	
	// MARK: - Properties
	private var presentationWindow = UIWindow()
	internal lazy var didComplete = PublishSubject<ASAuthorization>()
	
	
	// MARK: - Initializers
	public init(controller: ASAuthorizationController) {
		super.init(parentObject: controller, delegateProxy: ASAuthProxy.self)
	}
	
	// MARK: - Methods
	static func registerKnownImplementations() {
		self.register {
			ASAuthProxy(controller: $0)
		}
	}
	
	static func currentDelegate(for object: ASAuthorizationController) -> ASAuthorizationControllerDelegate? {
		return object.delegate
	}
	
	static func setCurrentDelegate(_ delegate: ASAuthorizationControllerDelegate?, to object: ASAuthorizationController) {
		object.delegate = delegate
	}
	
	// MARK: - Completed
	deinit {
		self.didComplete.onCompleted()
	}
}

// MARK: - ASAuthorizationControllerDelegate
extension ASAuthProxy: ASAuthorizationControllerDelegate {
	
	func authorizationController(
		controller: ASAuthorizationController,
		didCompleteWithAuthorization authorization: ASAuthorization
	) {
		didComplete.onNext(authorization)
		didComplete.onCompleted()
	}
	
	func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
		if (error as NSError).code == ASAuthorizationError.canceled.rawValue {
			didComplete.onCompleted()
			return
		}
		didComplete.onError(error)
	}
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension ASAuthProxy: ASAuthorizationControllerPresentationContextProviding {
	
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		return self.presentationWindow
	}
}

extension Reactive where Base: ASAuthorizationAppleIDProvider {
	
	public func login(scope: [ASAuthorization.Scope]? = nil) -> Observable<ASAuthorization> {
		let request = base.createRequest()
		request.requestedScopes = scope
		
		let controller = ASAuthorizationController(authorizationRequests: [request])
		
		let proxy = ASAuthProxy.proxy(for: controller)
		
		controller.presentationContextProvider = proxy
		controller.performRequests()
		
		return proxy.didComplete
	}
}
