//
//  MainAnimalView.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/06/27.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit

import RxGesture
import SiriUIKit

class MainAnimalView: BaseView {
  private let name: String
  private let days: String
  
  private lazy var mainAnimalInfoContainerView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    return view
  }()
  
  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    let text = "\(name)와 함께한지"
    let attributedString = NSMutableAttributedString(string: text)
    let blackAttributes: [
      NSAttributedString.Key: Any
    ] = [
      .foregroundColor:
        GalapagosAsset.black제목DisplayHeadingBody.color
    ]
    attributedString.addAttributes(
      blackAttributes,
      range: NSRange(
        location: 0,
        length: text.count
      )
    )
    let greenAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: GalapagosAsset.green.color]
    let greenRange = (text as NSString).range(of: name)
    attributedString.addAttributes(
      greenAttributes,
      range: greenRange
    )
    label.attributedText = attributedString
    label.font = GalapagosFontFamily.Pretendard
      .semiBold
      .font(size: 22)
    return label
  }()
  
  private lazy var daysContainerView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    return view
  }()
  
  private lazy var dayLabel: UILabel = {
    let label = UILabel()
    let text = "일째"
    let attributedString = NSMutableAttributedString(
      string: text
    )
    let blackAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: GalapagosAsset.black제목DisplayHeadingBody.color
    ]
    attributedString.addAttributes(
      blackAttributes,
      range: NSRange(
        location: 0,
        length: text.count
      )
    )
    label.attributedText = attributedString
    
    label.font = GalapagosFontFamily.Pretendard.bold.font(size: 18)
    return label
  }()
  
  private lazy var numberStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.spacing = 6
    return stackView
  }()
  
  private lazy var mainAnimalImage: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFill
    image.cornerRadius = 12
    return image
  }()
  
  lazy var mainAnimalDiaryButton: UIButton = {
    let button = UIButton()
    button.isUserInteractionEnabled = true
    button.setImage(
      GalapagosAsset._56x56diaryRoundActive.image,
      for: .normal
    )
    return button
  }()
  
  init(name: String, days: String) {
    self.name = name
    self.days = days
    super.init(frame: .zero)
    self.mainAnimalImage.image = #imageLiteral(resourceName: "AnimalSample") // 임시 주입, 실제로는 url
  }
  
  override func setAddSubView() {
    self.addSubviews(
      [
        mainAnimalInfoContainerView,
        mainAnimalImage,
        mainAnimalDiaryButton
      ]
    )
    
    [nameLabel, daysContainerView]
      .forEach { subview in
        mainAnimalInfoContainerView.addSubview(subview)
      }
    
    [ numberStackView, dayLabel ]
      .forEach { subview in
        daysContainerView.addSubview(subview)
      }
    
    createNumberBoxIntoNumberStackView(
      numberStackView: numberStackView,
      days: self.days
    )
  }
  
  func createNumberBoxIntoNumberStackView(
    numberStackView: UIStackView,
    days: String
  ) {
    days
      .map{ String($0) }
      .forEach { str in
        let view = RadiusNumberView(number: str)
        numberStackView.addArrangedSubview(view)
      }
  }
  
  override func setConstraint() {
    mainAnimalInfoContainerView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.horizontalEdges.equalToSuperview()
    }
    
    mainAnimalImage.snp.makeConstraints { make in
      make.top.equalTo(mainAnimalInfoContainerView.snp.bottom).offset(25)
      make.horizontalEdges.equalToSuperview()
      
      make.width.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    
    nameLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.centerX.equalToSuperview()
    }
    
    daysContainerView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(nameLabel.snp.bottom).offset(8)
      make.bottom.equalToSuperview()
    }
    
    numberStackView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.verticalEdges.equalToSuperview()
    }
    
    dayLabel.snp.makeConstraints { make in
      make.leading.equalTo(numberStackView.snp.trailing).offset(8)
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview()
    }
    
    mainAnimalDiaryButton.snp.makeConstraints { make in
      make.trailing.bottom.equalToSuperview().inset(14)
      make.size.equalTo(56)
    }
  }
}


final class RadiusNumberView: BaseView {
  private let number: String
  
  private let shadowView = RadiusBoxView(radius: 5, style: .shadow)
  private lazy var numberLabel: UILabel = {
    let label = UILabel()
    let text = number
    let attributedString = NSMutableAttributedString(
      string: text
    )
    let blackAttributes: [
      NSAttributedString.Key: Any] = [
        .foregroundColor: GalapagosAsset.black제목DisplayHeadingBody.color
      ]
    attributedString.addAttributes(blackAttributes, range: NSRange(location: 0, length: text.count))
    label.attributedText = attributedString
    
    label.font = GalapagosFontFamily.Pretendard.bold.font(size: 18)
    return label
  }()
  
  init(number: String) {
    self.number = number
    super.init(frame: .zero)
  }
  
  override func setAddSubView() {
    self.addSubview(shadowView)
    shadowView.addSubview(numberLabel)
  }
  
  override func setConstraint() {
    shadowView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.edges.equalToSuperview()
      make.size.equalTo(40)
    }
    
    numberLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
}

// MARK: - URL 이미지 로드 Test 위한 임시 코드 (아직 이미지 처리 방식 고려 X)
// test용 임시, 이미지 처리는 아직 고민 사항
private extension UIImageView {
  func load(url: URL) {
    DispatchQueue.global().async { [weak self] in
      if let data = try? Data(contentsOf: url) {
        if let image = UIImage(data: data) {
          DispatchQueue.main.async {
            self?.image = image
          }
        }
      }
    }
  }
}
