//
//  AddAnimalViewModel.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/06/20.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class AddAnimalViewModel: ViewModelType {
  struct Input {
    let backButtonTapped: Signal<Void>
    let profileTapped: Signal<Void>
  }
  
  struct Output {}
  
  var disposeBag: DisposeBag = DisposeBag()
  weak var coordinator: AddAnimalCoordinator?
  
  init(coordinator: AddAnimalCoordinator) {
    self.coordinator = coordinator
  }
  
  func transform(input: Input) -> Output {
    input.backButtonTapped
      .emit(onNext: { [weak self] _ in
        self?.coordinator?.finish()
      })
      .disposed(by: disposeBag)
    
    input.profileTapped
      .emit(onNext: { _ in
        print("터치 범위 확인")
      })
      .disposed(by: disposeBag)
    
    return Output()
  }
}
