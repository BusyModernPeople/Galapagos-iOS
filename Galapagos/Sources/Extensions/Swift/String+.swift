//
//  String+.swift
//  Galapagos
//
//  Created by Siri on 2023/10/04.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//
import CryptoKit

import Foundation

extension String {
	
	func toSha256() -> String {
		let data = Data(self.utf8)
		let hashedData = SHA256.hash(data: data)
		let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
		
		return hashString
	}
	
	static var errorDetected: String {
		return "오류가 발생했습니다.\n잠시 후 다시 시도해주세요."
	}
}
