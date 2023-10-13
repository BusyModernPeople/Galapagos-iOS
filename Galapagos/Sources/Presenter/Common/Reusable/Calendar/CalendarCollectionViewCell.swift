//
//  CalendarCollectionViewCell.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/08/06.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import SnapKit
import UIKit

final class CalendarCollectionViewCell: UICollectionViewCell {
  
  // MARK: - UI
  private var isCurrentDay: Bool = false
  private var myDate: Date?
  private lazy var eventDot: UIView = {
    let dotView = UIView()
    dotView.backgroundColor = GalapagosAsset.green.color
    dotView.isHidden = true
    return dotView
  }()
  
  private let dayLabel: UILabel = {
    let label = UILabel()
    label.font = GalapagosFontFamily.Pretendard.medium.font(size: 14)
    label.textAlignment = .center
    return label
  }()
    
  // MARK: - Properties
  static let identifier = "CalendarCollectionViewCell"
  var day: String = "" // 디퍼블로 개선 후 private 변경 
  
  // MARK: - Initializers
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configure()
  }
  
  // MARK: - LifeCycle
  override func layoutSubviews() {
    super.layoutSubviews()
    self.contentView.layer.cornerRadius = bounds.width / 2
    self.eventDot.layer.cornerRadius = eventDot.bounds.width / 2.0
    self.eventDot.clipsToBounds = true
  }
  
  // MARK: - Methods
  private func configure() {
    self.contentView.addSubview(self.dayLabel)
    self.contentView.addSubview(eventDot)
    
    eventDot.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.centerX.equalToSuperview()
      make.width.equalTo(6)
      make.height.equalTo(eventDot.snp.width)
    }

    dayLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
    }
  }
  
  override var isSelected: Bool {
    willSet{
      super.isSelected = newValue
      if newValue {
        self.contentView.backgroundColor = GalapagosAsset.green.color
        self.dayLabel.textColor = .white
      } else {
        self.contentView.backgroundColor = .clear
        self.dayLabel.textColor = isCurrentDay ? GalapagosAsset.green.color : .black
      }
    }
  }

  func configure(day: String, hasEvent: Bool, isToday: Bool) { // cell Setting
    self.day = day
    self.isCurrentDay = isToday
    self.isSelected = self.isSelected
    dayLabel.text = day
    eventDot.isHidden = !hasEvent
  }
}
