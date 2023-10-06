//
//  CertifyEmailViewModel.swift
//  Galapagos
//
//  Created by Siri on 2023/10/02.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation
import UIKit

import RxSwift

final class CertifyEmailViewModel: ViewModelType {
    
    struct Input {
        let email: Observable<String>
        let sendCodeButtonTapped: Observable<Void>
    }
    
    struct Output {
        let receivedMessage: Observable<String>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    private let usecase: CertifyEmailUsecase
    
    init(usecase: CertifyEmailUsecase) {
        self.usecase = usecase
    }
    

    func transform(input: Input) -> Output {
        
        let receivedMessage = input.sendCodeButtonTapped
            .withLatestFrom(input.email)
            .withUnretained(self)
            .flatMapLatest{ owner, email -> Observable<String> in
                let body = SendCodeWithEmailBody(email: email)  /// 뷰모델에서부터 body를 완성해서 넘겨주는게 맞는걸까....?
                return owner.usecase.sendCodeWithEmail(body: body)
                    .asObservable()
            }
        
        return Output(
            receivedMessage: receivedMessage
        )
    }
    
}
