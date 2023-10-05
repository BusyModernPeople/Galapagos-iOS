//
//  CertifyCodeView.swift
//  Galapagos
//
//  Created by Siri on 2023/10/02.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import Foundation
import UIKit
import SiriUIKit

import RxSwift
import RxCocoa

final class CertifyCodeView: BaseView {
    
    // MARK: - UI Components
    public lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일로 전송된 인증번호를 입력해주세요"
        label.font = SiriUIKitFontFamily.Pretendard.medium.font(size: 14)
        return label
    }()
    
    public lazy var timerTextField: GalapagosTextField_Timer = {
        let textField = GalapagosTextField_Timer(
            placeHolder: "인증코드 6자리 입력",
            maxCount: 6,
            errorMessage: ""
        )
        return textField
    }()
    
    
    // MARK: - Properties
    
    
    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    override func setAddSubView() {
        super.setAddSubView()
        addSubviews([
            infoLabel,
            timerTextField
        ])
    
    }
    
    override func setConstraint() {
        super.setConstraint()
        
        infoLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        timerTextField.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(68)
        }
    
        
    }
    
    override func setAttribute() {
        super.setAttribute()
    }
    
    override func bind() {
        super.bind()
    }
    // MARK: - Methods
}
