//
//  SignInViewModel.swift
//  Galapagos
//
//  Created by 조용인 on 2023/06/07.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewModel: ViewModelType{
  
  struct Input {
    let emailSignUpBtnTapped: Observable<Void>
    let emailSignInBtnTapped: Observable<Void>
  }
  
  struct Output {}
  
  var disposeBag: DisposeBag = DisposeBag()
  weak var coordinator: AuthCoordinator?
  
  init(
    coordinator: AuthCoordinator
  ) {
    self.coordinator = coordinator
  }
  
  
  func transform(input: Input) -> Output {
    input.emailSignUpBtnTapped.subscribe(onNext: {
      [weak self] _ in
      guard let self = self else {return}
      self.coordinator?.userActionState.accept(.EmailSignUp)
    }).disposed(by: disposeBag)
    
    input.emailSignInBtnTapped.subscribe(onNext: {
      [weak self] _ in
      guard let self = self else {return}
      self.coordinator?.userActionState.accept(.EmailSignIn)
    }).disposed(by: disposeBag)
    
    return Output()
  }
  
  
}
