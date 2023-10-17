//
//  BaseViewController.swift
//  Galapagos
//
//  Created by 조용인 on 2023/05/25.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit

import RxSwift
import SnapKit


class BaseViewController: UIViewController {
  
  // MARK: - Properties
  var disposeBag = DisposeBag()
  
  // MARK: - Methods
  override func viewDidLoad() {
    super.viewDidLoad()
		self.view.backgroundColor = GalapagosAsset.white기본화이트.color
    
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
  required init(coder: NSCoder) {
    fatalError("init(coder:) is called.")
  }
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
}
