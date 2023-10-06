//
//  SnapKit+.swift
//  Galapagos
//
//  Created by Siri on 2023/10/05.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation
import SnapKit


extension ConstraintMakerEditable {
    
    public enum OffsetType: Int {
        case _4 = 4
        case _6 = 6
        case _8 = 8
        case _10 = 10
        case _12 = 12
        case _16 = 16
        case _20 = 20
        case _32 = 32
        case _36 = 36
        case _40 = 40
        case _50 = 50
        case _56 = 56
        
    }
    
    @discardableResult
    public func GalapagosOffset(offset: OffsetType, reverse: Bool = false) -> ConstraintMakerEditable {
        _ = reverse ? self.offset(-offset.rawValue) : self.offset(offset.rawValue)
        return self
    }
    
    @discardableResult
    public func GalapagosInset(inset: OffsetType) -> ConstraintMakerEditable {
        self.inset(inset.rawValue)
        return self
    }
}
