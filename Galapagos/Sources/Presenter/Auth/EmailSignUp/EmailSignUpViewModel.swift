//
//  EmailSignUpViewModel.swift
//  Galapagos
//
//  Created by 조용인 on 2023/06/07.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SiriUIKit

class EmailSignUpViewModel: ViewModelType{
    
    struct Input {
        let backButtonTapped: Signal<Void>
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
        let scrollTo: Observable<Int>
        let backScrollTo: Observable<Int>
        let readyForNextButton: Observable<Bool>
    }
    
    // MARK: - Properties
    private var userSignUpUsecase: UserSignUpUsecase
    
    var disposeBag: DisposeBag = DisposeBag()
    weak var coordinator: AuthCoordinator?
    
    var readyForNextButton = BehaviorRelay<Bool>(value: false)
    var letsGoSignUp = BehaviorRelay<Bool>(value: false)
    
    var email = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    var nickname = BehaviorRelay<String>(value: "")
    var socialType = BehaviorRelay<String>(value: "email")
    
    // MARK: - Initializers
    init(
        coordinator: AuthCoordinator,
        userSignUpUsecase: UserSignUpUsecase
    ) {
        self.coordinator = coordinator
        self.userSignUpUsecase = userSignUpUsecase
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        
        input.backButtonTapped
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                self.readyForNextButton.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.nextButtonTapped
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                self.readyForNextButton.accept(false)
            })
            .disposed(by: disposeBag)
        
        let signupBody = Observable
            .combineLatest(email, password, nickname, socialType)
            .map{ UserSignUpBody(email: $0, password: $1, nickName: $2, socialType: $3) }
        
        
        //TODO: - 회원가입 시, 에러처리 아직 안함. 그리고, pageScroll 되는 부분도 아직 작성X
        //TODO: - 회원가입 성공 시, JWT 토큰을 UserDefaults에 저장해야함. -> Manager 따로 만들어주기
        
        letsGoSignUp
            .withLatestFrom(signupBody)
            .withUnretained(self)
            .flatMapLatest { owner, body in
                owner.userSignUpUsecase.userSignUp(body: body)
            }
            .subscribe(onNext: { model in
                UserDefaults.standard.setValue(model.jwt, forKey: "JWT")
                UserDefaults.standard.setValue(model.nickName, forKey: "NICKNAME")
            })
            .disposed(by: disposeBag)
        
        
        
        
        let scrollTo = input.nextButtonTapped
            .asObservable()
            .map{ return 1 }
        
        let backScrollTo = input.backButtonTapped
            .asObservable()
            .map{ return 1 }
        
        return Output(
            scrollTo: scrollTo,
            backScrollTo: backScrollTo,
            readyForNextButton: readyForNextButton.asObservable()
        )
    }
}
