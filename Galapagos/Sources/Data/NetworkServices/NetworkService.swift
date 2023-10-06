//
//  NetworkService.swift
//  Galapagos
//
//  Created by 조용인 on 2023/07/03.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation

import RxSwift

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
    
    func request<T: Decodable>(_ endpoint: Endpoint, decodeTo type: T.Type) -> Single<T> {
        return self.request(endpoint)
            .flatMap { response, data -> Observable<T> in
                if response.statusCode == 200 {
                    if let model = Utility.decode(T.self, from: data) {
                        return .just(model)
                    } else {
                        return .error(NetworkError.decodingFailed)
                    }
                } else {
                    let errorData = Utility.decodeError(from: data)
                    return .error(NetworkError.customError(code: errorData.errorCode, message: errorData.errorMessages))
                }
            }
            .asSingle()
    }

}

