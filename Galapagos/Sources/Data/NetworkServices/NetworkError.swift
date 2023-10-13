//
//  NetworkError.swift
//  Galapagos
//
//  Created by 조용인 on 2023/07/03.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation

struct ServerError: Codable {
	let status: Int
	let errorCode: Int
	let errorMessages: String
}


public enum NetworkError: LocalizedError {
	case invalidURL
	case invalidResponse
	case decodingFailed
	case customError(code: Int?, message: String?)
	
	public var errorDescription: String? {
		switch self {
		case .invalidURL:
			return "The URL is invalid."
		case .invalidResponse:
			return "The response is invalid."
		case .decodingFailed:
			return "Failed to decode the object."
		case .customError(_, let message):
			return "\(message ?? "Unknown Error")"
			
			// 코드까지 확인 하고 싶으면, 아래 녀석 사용하자
			//          case .customError(let code, let message):
			//              return "Error \(code ?? 999): \(message ?? "Unknown Error")"
			
		}
	}
	
	static func error(from code: Int, serverMessage: String?) -> NetworkError {
		let defaultMessage: String
		switch code {
		case 400:
			defaultMessage = "Bad Request"
		case 401:
			defaultMessage = "Unauthorized"
		case 403:
			defaultMessage = "Forbidden"
		case 404:
			defaultMessage = "Not Found"
		default:
			defaultMessage = "Unknown Error"
		}
		
		let message = serverMessage ?? defaultMessage
		return .customError(code: code, message: message)
	}
}
