//
//  EmailCheckViewModel.swift
//  Galapagos
//
//  Created by Siri on 2023/10/02.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation
import UIKit

import RxSwift
import RxRelay

final class EmailCheckViewModel: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var certifyCodeIsHidden = BehaviorRelay<Bool>(value: true)
    
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
