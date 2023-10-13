//
//  AddAnimalViewController.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/06/20.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//


import RxCocoa
import RxSwift
import SiriUIKit
import SnapKit
import UIKit

class AddAnimalViewController: BaseViewController {
  
  // MARK: - UI
  
  private lazy var navigationBar: GalapagosNavigationBarView = {
    let navigationBar = GalapagosNavigationBarView()
    navigationBar.setTitleText("반려동물 추가")
    return navigationBar
  }()
  
  private lazy var profileContainer = UIView()
  private lazy var nameContainer = UIView()
  private lazy var genderContainer = UIView()
  private lazy var speciesContainer = UIView()
  private lazy var adoptionDateContainer = UIView()
  private lazy var birthDateContainer = UIView()
  
  private lazy var profileImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = GalapagosAsset.gray3DisableButtonBg.color
    imageView.layer.cornerRadius = 12
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private lazy var circleShadowCameraView = {
    let radiusBoxView = RadiusBoxView(radius: 16, style: .shadow)
    radiusBoxView.layer.shadowColor = GalapagosAsset.black제목DisplayHeadingBody.color.withAlphaComponent(0.25).cgColor
    radiusBoxView.layer.shadowOffset = CGSize(width: 0, height: 4)
    radiusBoxView.layer.shadowRadius = 4.0 // Blur
    radiusBoxView.layer.shadowOpacity = 1
    return radiusBoxView
  }()
  
  private let cameraImageView = UIImageView(image: GalapagosAsset._16x16CameraDefault.image)
  
  private let nameLabel: UILabel = AddAnimalViewTextLabel(title: "이름*")
  
  private lazy var setMainAnimalButton: UIButton = {
    let button = UIButton()
    button.setImage(GalapagosAsset._24x24checkRoundDefault.image, for: .normal)
    button.setImage(GalapagosAsset._24x24checkRoundActive.image, for: .selected)
    button.contentMode = .scaleAspectFill
    return button
  }()
  
  private lazy var setMainButtonInfoLabel: UILabel = {
    let label = UILabel()
    label.text = "대표동물로 설정하기"
    label.textColor = GalapagosAsset.gray1본문Body.color
    label.font = GalapagosFontFamily.Pretendard.medium.font(size: 14)
    return label
  }()
  
  
  // MARK: - Properties
  
  private let viewModel: AddAnimalViewModel
  
  // MARK: - Initializers
  
  init(
    viewModel: AddAnimalViewModel
  ) {
    self.viewModel = viewModel
    super.init()
  }
  
  // MARK: - LifeCycle
  
  // MARK: - Methods
  
  override func setAddSubView() {
    self.view.addSubviews([
      navigationBar,
      profileContainer,
      nameContainer,
      genderContainer,
      speciesContainer,
      adoptionDateContainer,
      birthDateContainer,
    ])
    
    profileContainer.addSubview(profileImageView)
    profileImageView.addSubview(circleShadowCameraView)
    circleShadowCameraView.addSubview(cameraImageView)
    
    nameContainer.addSubviews([
      nameLabel,
      setMainAnimalButton,
      setMainButtonInfoLabel
    ])
  }
  
  override func setConstraint() {
    navigationBar.snp.makeConstraints{ navigationBar in
      navigationBar.top.equalTo(self.view.safeAreaLayoutGuide)
      navigationBar.leading.trailing.equalToSuperview()
      navigationBar.height.equalTo(50)
    }
    
    profileContainer.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom).offset(38)
      make.leading.equalTo(profileImageView)
      make.trailing.equalTo(profileImageView.snp.trailing).offset(6)
      make.bottom.equalTo(circleShadowCameraView)
    }
    profileContainer.backgroundColor = .blue
    
    profileImageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.centerX.equalTo(self.view.snp.centerX)
      make.size.equalTo(110)
    }
    
    circleShadowCameraView.snp.makeConstraints { make in
      make.size.equalTo(32)
      make.trailing.equalToSuperview().offset(6)
      make.bottom.equalToSuperview().offset(6)
    }
    
    cameraImageView.snp.makeConstraints { make in
      make.center.equalTo(circleShadowCameraView.snp.center)
    }
    
    nameContainer.snp.makeConstraints { make in
      make.top.equalTo(profileContainer.snp.bottom).offset(64)
      make.centerX.equalToSuperview()
      make.horizontalEdges.equalToSuperview().inset(galpagosHorizontalOffset)
    }
    
    nameLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.centerY.equalTo(setMainAnimalButton.snp.centerY)
    }
    
    setMainAnimalButton.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.trailing.equalTo(setMainButtonInfoLabel.snp.leading).offset(-6)
    }
    
    setMainButtonInfoLabel.snp.makeConstraints { make in
      make.centerY.equalTo(setMainAnimalButton.snp.centerY)
      make.trailing.equalToSuperview()
    }
  }
  
  override func setAttribute() {
    
  }
  
  
  override func bind() { // 대표 동물로 설정하기, 이름, 성별, 종, 입양일, 탄생일,
    let input = AddAnimalViewModel.Input(
      backButtonTapped: navigationBar.backButton.rx.tap.asSignal(),
      profileTapped: profileContainer.rx.tapGesture()
        .when(.recognized)
        .map { [weak self] _ in
          self?.present(CalendarViewController(events: ["2023-08-09"]), animated: false) // 테스트용, 추후 달력 버튼 위치로 변경
        }
        .asSignal(onErrorJustReturn: ())
    )
    
    _ = viewModel.transform(input: input)
  }
}
