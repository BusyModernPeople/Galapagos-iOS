//
//  Coordinator.swift
//  Galapagos
//
//  Created by 조용인 on 2023/05/24.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol CoordinatorDelegate: AnyObject {
  func didFinish(childCoordinator: Coordinator)   // navigator가 back될 때, childCoordinator들을 모두 지워주기 위함이다.
}

protocol Coordinator: AnyObject{
  var disposeBag: DisposeBag { get }
  var navigationController: UINavigationController {get set}
  
  var childCoordinators: [Coordinator] {get set}
  var delegate: CoordinatorDelegate? {get set}
  
  func setState()
  func start()
  func finish()
  
  // MARK: Navigation 동작
  func pushViewController(viewController vc: UIViewController )
  func popViewController()
  
  // MARK: Modal 동작
  func presentViewController(viewController vc: UIViewController )
  func dismissViewController()
  
}

extension Coordinator{
  
  /// finish가 호출되면 -> delegate를 self로 할당하면서 didFinish를 정의한놈의 child를 모두 지워줌
  func finish() {
    childCoordinators.removeAll()
    delegate?.didFinish(childCoordinator: self)
  }
  
  
  func pushViewController(viewController vc: UIViewController ){
    self.navigationController.setNavigationBarHidden(
      true, 
      animated: false
    ) // push되는 네비바는 기본적으로 false -> 커스텀 하는걸로 하는건 어떤지
    self.navigationController.pushViewController(vc, animated: true)
  }
  
  func popViewController() {
    self.navigationController.popViewController(animated: true)
  }
  
  func presentViewController(viewController vc: UIViewController){
    self.navigationController.present(vc, animated: true)
  }
  
  func dismissViewController() {
    navigationController.dismiss(animated: true)
  }
  
}
