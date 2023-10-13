//
//  DiaryViewModel.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/06/17.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class DiaryViewModel: ViewModelType {
  struct Input {
    let backButtonTapped: Signal<Void>
    let buttonTapped: Signal<Void>
  }
  
  struct Output {}
  
  var disposeBag: DisposeBag = DisposeBag()
  weak var coordinator: DiaryCoordinator?
  
  init(coordinator: DiaryCoordinator) {
    self.coordinator = coordinator
  }
  
  func transform(input: Input) -> Output {
    input.backButtonTapped
      .emit(onNext: { [weak self] _ in
        self?.coordinator?.finish()
      })
      .disposed(by: disposeBag)
    input.buttonTapped
      .emit(onNext: { [weak self] _ in
        self?.coordinator?.userActionState.accept(.addDiary)
      })
      .disposed(by: disposeBag)
    return Output()
  }
}
