//
//  SplashViewController.swift
//  Galapagos
//
//  Created by 조용인 on 2023/05/23.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import SnapKit
import Then
import UIKit

class SplashViewController: BaseViewController {
  
  private let viewModel: SplashViewModel
  
  init(
    viewModel: SplashViewModel
  ) {
    self.viewModel = viewModel
    super.init()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.checkAutoSignIn()
  }
  
  override func setConstraint() {
    
  }
  
  override func setAddSubView() {
    
  }
}
