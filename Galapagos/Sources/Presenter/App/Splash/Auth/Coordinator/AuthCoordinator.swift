//
//  AuthCoordinator.swift
//  Galapagos
//
//  Created by 조용인 on 2023/05/26.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit

class AuthCoordinator: Coordinator {
    var childCoordinatorType: Any
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var delegate: CoordinatorDelegate?
    
    init(
        navigationController: UINavigationController,
        childCoordinatorType: AuthCoordinatorChild
    ){
        self.navigationController = navigationController
        self.childCoordinatorType = childCoordinatorType
    }
    
    func start() {
        <#code#>
    }
    
    func moveToNextViewController(to childType: Any) {
        <#code#>
    }
    
    
}
