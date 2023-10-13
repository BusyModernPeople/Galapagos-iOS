//
//  MoveCommunityShadowView.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/06/27.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit

import RxSwift
import SiriUIKit
import SnapKit

final class EmptyStarCommunityView: BaseView {
  
  private var shadowView = RadiusBoxView(radius: 12, style: .shadow)
  
  private lazy var communityStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = UIScreen.main.bounds.width / 24.375
    return stackView
  }()
  
  private lazy var moveCommunityTabInfoLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    let text = "아직 즐겨찾기한 게시판이 없어요.🥲\n커뮤니티에서 즐겨찾기를 설정해보세요!"
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = label.font.xHeight * 0.5  // 행간 150%
    paragraphStyle.alignment = .center
    
    let attributedString = NSMutableAttributedString(string: text)
    attributedString.addAttribute(
      .paragraphStyle,
      value: paragraphStyle,
      range: NSRange(location: 0, length: text.count)
    )
    
    let blackAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: GalapagosAsset.black제목DisplayHeadingBody.color
    ]
    attributedString.addAttributes(
      blackAttributes,
      range: NSRange(location: 0, length: text.count)
    )
    
    let greenAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: GalapagosAsset.green.color
    ]
    let greenRange = (text as NSString)
      .range(of: "커뮤니티에서 즐겨찾기를 설정")
    attributedString.addAttributes(greenAttributes, range: greenRange)
    label.attributedText = attributedString
    label.font = GalapagosFontFamily.Pretendard.semiBold.font(size: 14)
    return label
  }()
  
  var moveCommunityTabButton: GalapagosButton =
  {
    let button = GalapagosButton(
      isRound: false,
      iconTitle: nil,
      type: .usage(.inactive),
      title: "커뮤니티로 이동하기"
    )
    return button
  }()
  // {
  //    let button = GalapagosButton(buttonStyle: .fill, isCircle: true)
  //    let spacing: CGFloat = 8
  //    let horizental: CGFloat = 20
  //    button.setTitle("커뮤니티로 이동하기", for: .normal)
  //    button.titleLabel?.adjustsFontSizeToFitWidth = true
  //    button.isUserInteractionEnabled = true
  //    button.setImage(GalapagosAsset._20x20arrowRight.image, for: .normal) //공식적인 이미지 X
  //    button.isEnabled = true
  //    button.semanticContentAttribute = .forceRightToLeft
  //    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing/2)
  //    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: 0)
  //    button.contentEdgeInsets = UIEdgeInsets(top: 0, left: horizental, bottom: 0, right: horizental)
  //
  //    return button
  //  }()
  
  override func setAddSubView() {
    self.addSubview(shadowView)
    
    shadowView.addSubview(communityStackView)
    [moveCommunityTabInfoLabel, moveCommunityTabButton].forEach { subview in
      communityStackView.addArrangedSubview(subview)
    }
  }
  override func setConstraint() {
    
    shadowView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.edges.equalToSuperview()
    }
    
    communityStackView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    moveCommunityTabInfoLabel.snp.makeConstraints { make in
      make.width.lessThanOrEqualToSuperview()
    }
    
    moveCommunityTabButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.height.equalTo(52)
    }
  }
}
