//
//  Xcconnfig.swift
//  Galapagos
//
//  Created by Siri on 2023/10/04.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation

struct Xcconfig {
	static let BASE_URL = Bundle.main.infoDictionary?["Base_Url"] as? String ?? ""
	
}
