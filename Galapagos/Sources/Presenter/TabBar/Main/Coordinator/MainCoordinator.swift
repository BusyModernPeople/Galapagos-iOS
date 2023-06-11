//
//  MainCoordinator.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/06/11.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class MainCoordinator: Coordinator {
    enum MainCoordinatorFlow {
        case main, detailDiary
    }
    
    var navigationController: UINavigationController
    var parentsCoordinator: TabBarCoordinator
    
    var userActionState: PublishRelay<MainCoordinatorFlow> = PublishRelay()
    var childCoordinators: [Coordinator] = []
    var disposeBag: DisposeBag = DisposeBag()
    var delegate: CoordinatorDelegate?
    
    init(
        navigationController: UINavigationController,
        parentsCoordinator: TabBarCoordinator
    ) {
        self.navigationController = navigationController
        self.parentsCoordinator = parentsCoordinator
        self.setState()
    }
    
    func setState(){
        self.userActionState
            .debug()
            .subscribe(onNext: { [weak self] state in
                print("💗💗💗 MainCoordinator: \(state) 💗💗💗")
                guard let self = self else {return}
                switch state{
                case .main:
                    let mainViewController = MainViewController(
                        viewModel: MainViewModel(
                            ///
                            coordinator: self
                        )
                    )
                    self.pushViewController(viewController: mainViewController)

                case .detailDiary:
                    self.popViewController()
                    self.parentsCoordinator.userActionState.accept(.diary)
                }
            }).disposed(by: disposeBag)
    }
    
    func start() {
        self.userActionState.accept(.main)
    }
}