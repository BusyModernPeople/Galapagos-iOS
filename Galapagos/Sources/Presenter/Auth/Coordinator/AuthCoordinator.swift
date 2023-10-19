//
//  AuthCoordinator.swift
//  Galapagos
//
//  Created by 조용인 on 2023/05/26.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class AuthCoordinator: Coordinator {
  // MARK: - Navigation DEPTH 1 -
  enum AuthCoordinatorChild{
    case signIn
    case emailSignUp
    case emailSignIn
    /// SignIn이 AuthHome의 역할
  }
  
  // MARK: - Need To Initializing
  var disposeBag: DisposeBag
  var navigationController: UINavigationController
  
  // MARK: - Don't Need To Initializing
  var childCoordinators: [Coordinator] = []
  var delegate: CoordinatorDelegate?
  var userActionState: PublishRelay<AuthCoordinatorChild> = PublishRelay()
  /// init에서만 호출하고, stream을 유지하기위해 BehaviorSubject 사용
  
  init(
    navigationController: UINavigationController
  ){
    self.navigationController = navigationController
    self.disposeBag = DisposeBag()
    self.setState()
  }
  
  func setState() {
    self.userActionState
      .subscribe(onNext: { [weak self] state in
        guard let self = self else {return}
        switch state{
        case .signIn:
          let signInViewController = SignInViewController(
            viewModel: SignInViewModel(
              /// 여기에 나중에는 useCase도 추가 되어야겠지
              coordinator: self
//              socialCreateUsecase: DefaultSocialUserCreateUseCase()
            )
          )
          if self.navigationController.viewControllers.contains(where: {$0 is SignInViewController}) {
            self.navigationController.popViewController(animated: true)
          }else {
            self.pushViewController(viewController: signInViewController)
          }
        case .emailSignUp:
          let emailSignUpViewController = EmailSignUpViewController(
            viewModel: EmailSignUpViewModel(
              coordinator: self,
              userSignUpUsecase: DefaultUserSignUpUsecase(
                userRepository: DefaultUserRepository()
              )
            )
          )
          if self.navigationController.viewControllers.contains(where: {$0 is EmailSignUpViewController}) {
            self.navigationController.popViewController(animated: true)
          }else {
            self.pushViewController(viewController: emailSignUpViewController)
          }
        case .emailSignIn:
          let emailSignInViewController = EmailSignInViewController(
						viewModel: EmailSignInViewModel(
							coordinator: self,
							userEmailSignInUsecase: DefaultUserEmailSignInUsecase(
								userRepository: DefaultUserRepository()
							)
						)
          )
          if self.navigationController.viewControllers.contains(where: {$0 is EmailSignInViewController}) {
            self.navigationController.popViewController(animated: true)
          }else {
            self.pushViewController(viewController: emailSignInViewController)
          }
        }
        
      }).disposed(by: disposeBag)
  }
  
  func start() {
    self.userActionState.accept(.signIn)
  }
  
}
