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


final class DefaultNetworkService: NetworkService {
	// MARK: - Properties
	private let session: URLSession = .shared
	
	// MARK: - Methods
	func request(_ endpoint: Endpoint) -> Observable<(HTTPURLResponse, Data)> {
		guard let urlRequest = endpoint.toURLRequest() else {
			return .error(NetworkError.invalidURL)
		}
		return session.rx
			.response(request: urlRequest)
			.map { ($0.response, $0.data) }
	}
	
	func request(_ endpoint: Endpoint) -> Single<Data> {
		return self.request(endpoint)
			.do(onSubscribe: {
				GalapagosIndecatorManager.shared.show()
			}, onDispose: {
				GalapagosIndecatorManager.shared.hide()
			})
			.flatMap { response, data -> Observable<Data> in
				if response.statusCode == 200 {
					return .just(data)
				} else {
					let errorData = Utility.decodeError(from: data)
					return .error(
						NetworkError.customError(
							code: errorData.errorCode,
							message: errorData.errorMessages
						)
					)
				}
			}
			.asSingle()
	}
	
}
