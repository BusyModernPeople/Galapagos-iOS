//
//  CommunityCoordinator.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/06/11.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import RxRelay
import RxSwift
import UIKit

class CommunityListCoordinator: Coordinator {
  
  // MARK: - Coordinator DEPTH 2 -
  
  // MARK: - Need To Initializing
    
  var navigationController: UINavigationController
  
  // MARK: - Don't Need To Initializing
    
  var childCoordinators: [Coordinator] = []
  var disposeBag: DisposeBag = DisposeBag()
  var delegate: CoordinatorDelegate?
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func setState() {
    //
  }
  
  func start() {
    //
  }
}
