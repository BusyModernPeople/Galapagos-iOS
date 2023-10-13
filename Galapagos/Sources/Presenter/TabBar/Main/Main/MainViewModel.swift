//
//  MainViewModel.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/06/11.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class MainViewModel: ViewModelType {
  struct Input {
    let addAnimalButtonTapped: Signal<Void>
    let moveCommunityTapped: Signal<Void>
    let moveMainAnimalDiaryTapped: Signal<Void>
  }
  
  struct Output {
    let hasMainAnimal: Driver<Bool> // 값을 가지고 오기 때문에 실제 적용 시 Bool 아닌 해당 Model 정보를 가져오는 게 좋을 듯 (isEmpty로 유무 판별)
    let hasStarCommunity: Driver<Bool> //
  }
  
  var disposeBag: DisposeBag = DisposeBag()
  weak var coordinator: MainCoordinator?
  
  init(coordinator: MainCoordinator) {
    self.coordinator = coordinator
  }
  
  func transform(input: Input) -> Output {
    input.addAnimalButtonTapped
      .emit(onNext: { [weak self] _ in
        self?.coordinator?.userActionState.accept(.addAnimal)
      })
      .disposed(by: disposeBag)
    
    input.moveCommunityTapped
      .emit(onNext: { [weak self] _ in
        self?.coordinator?.userActionState.accept(.moveCommunity)
      })
      .disposed(by: disposeBag)
    
    input.moveMainAnimalDiaryTapped
      .emit(onNext: { [weak self] _ in
        self?.coordinator?.userActionState.accept(.mainAnimalDiary)
      })
      .disposed(by: disposeBag)
    
    return Output(
      hasMainAnimal: Driver.just(false), // 강제 입력
      hasStarCommunity: Driver.just(false)
    )
  }
}
