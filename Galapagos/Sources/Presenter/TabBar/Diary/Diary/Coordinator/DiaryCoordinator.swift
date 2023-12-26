//
//  DiaryCoordinator.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/06/17.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import RxRelay
import RxSwift
import UIKit

class DiaryCoordinator: Coordinator {

  enum DiaryCoordinatorFlow {
    case addDiary // 초기화면 삭제
  }
  
  private var petIdx: String?
  
  var userActionState: PublishRelay<DiaryCoordinatorFlow> = PublishRelay()
  var delegate: CoordinatorDelegate?

  var navigationController: UINavigationController
  var childCoordinators: [Coordinator] = []
  var disposeBag: DisposeBag = DisposeBag()

  init(petIdx: String, navigationController: UINavigationController) {
    self.petIdx = petIdx
    self.navigationController = navigationController
    self.setState()
  }

  func setState() {
    self.userActionState
      .debug()
      .subscribe(onNext: { [weak self] state in
        print("🌱🌱🌱 DiaryCoordinator: \(state) 🌱🌱🌱")
        guard let self = self else { return }
        switch state {
        case .addDiary:
          self.pushToAddDiary(petIdx: "임시")
        }
      }).disposed(by: disposeBag)
  }

  func start() {
//    guard let PetIdx else { return } // 아직 안 사용
    let diaryViewController = DiaryViewController(
      viewModel: DiaryViewModel(
        coordinator: self
      )
    )
    self.pushViewController(viewController: diaryViewController)
  }
}

extension DiaryCoordinator: AddDiaryCoordinating {
  func pushToAddDiary(petIdx: String) {
    let addDiaryCoordinator = AddDiaryCoordinator(
      navigationController: self.navigationController
    )
    addDiaryCoordinator.delegate = self
    addDiaryCoordinator.start()
    self.childCoordinators.append(addDiaryCoordinator)
    
  }
}

extension DiaryCoordinator: CoordinatorDelegate {
  func didFinish(childCoordinator: Coordinator) {
    self.popViewController()
  }
}
