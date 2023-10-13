//
//  DiaryListViewModel.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/06/11.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class DiaryListViewModel: ViewModelType {
  struct Input {
    let buttonTapped: Signal<Void>
    let button2Tapped: Signal<Void>
  }
  
  struct Output {}
  
  var disposeBag: DisposeBag = DisposeBag()
  weak var coordinator: DiaryListCoordinator?
  
  init(coordinator: DiaryListCoordinator) {
    self.coordinator = coordinator
  }
  
  func transform(input: Input) -> Output {
    input.buttonTapped
      .emit(onNext: { [weak self] _ in
        self?.coordinator?.userActionState.accept(.diary)
      })
      .disposed(by: disposeBag)
    
    input.button2Tapped
      .emit(onNext: { [weak self] _ in
        self?.coordinator?.userActionState.accept(.addAnimal)
      })
      .disposed(by: disposeBag)
    return Output()
  }
}
