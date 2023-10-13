//
//  BaseView.swift
//  Galapagos
//
//  Created by 조용인 on 2023/06/13.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import RxSwift
import UIKit

public class BaseView: UIView {
  
  // MARK: - Properties
  var disposeBag = DisposeBag()
  
  // MARK: - Methods
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = GalapagosAsset.white기본화이트.color
    setAddSubView()
    setAttribute()
    setConstraint()
    bind()
  }
  
  func setAddSubView() {}
  func setConstraint() {}
  func setAttribute() {}
  func bind() {}
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) is called.")
  }
}
