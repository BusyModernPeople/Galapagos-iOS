//
//  NetworkService.swift
//  Galapagos
//
//  Created by 조용인 on 2023/07/03.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation

import RxSwift

protocol NetworkService {
	
	// MARK: - Methods
	func request(_ endpoint: Endpoint) -> Observable<(HTTPURLResponse, Data)>
	func request(_ endpoint: Endpoint) -> Single<Data>
}
