//
//  GalapagosButton.swift
//  Galapagos
//
//  Created by 조용인 on 2023/06/09.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//
import Foundation

import RxCocoa
import RxGesture
import RxSwift

import SnapKit

import UIKit

public final class GalapagosButton: UIView{
	
	// MARK: - UI
	private lazy var buttonLabel: UILabel = {
		var label = UILabel()
		label.font = SiriUIKitFontFamily.Pretendard.semiBold.font(size: 16)
		return label
	}()
	
	private lazy var buttonIcon: UIImageView = {
		var imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	private lazy var buttonStackView: UIStackView = {
		var stackView = UIStackView(arrangedSubviews: [buttonLabel, buttonIcon])
		stackView.axis = .horizontal
		stackView.alignment = .center
		stackView.spacing = 4
		return stackView
	}()
	
	
	// MARK: - Properties
	typealias GalapagosButton_56UISet = (boarderColor: UIColor, mainColor: UIColor, backgroundColor: UIColor)
	
	var disposeBag = DisposeBag()
	
	private var isRound: Bool
	private var iconTitle: String?
	private var title: String
	private var type: GalapagosButtonType
	
	public var rxType = BehaviorRelay<GalapagosButtonType>(value: .fill)
	
	// MARK: - Initializers
	
	/// 버튼의 `isRound`, `iconTitle`, `buttonType`, `title`을 설정합니다.
	/// - Parameters:
	///   - isRound : 버튼의 layer를 둥글게 할지 결정합니다.
	///   - iconTitle : 버튼의 이미지를 설정합니다. (nil이면 icon을 사용 안한다는 의미)
	///   - buttonType : 버튼의 타입을 결정함 ( ex: fill, outline, boldOutline )
	///   - title: 버튼의 타이틀을 설정합니다.
	public init(isRound: Bool, iconTitle: String?, type: GalapagosButtonType, title: String) {
		self.isRound = isRound
		self.iconTitle = iconTitle
		self.type = type
		self.title = title
		super.init(frame: .zero)
		
		self.setAddSubView()
		self.setConstraint()
		self.setAttribute()
		
		self.bind()
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	// MARK: - LifeCycle
	
	// MARK: - Methods
	
	private func setAddSubView() {
		self.addSubview(buttonStackView)
	}
	
	private func setConstraint() {
		buttonIcon.snp.makeConstraints {
			$0.width.height.equalTo(24)
		}
		
		buttonStackView.snp.makeConstraints {
			$0.center.equalToSuperview()
		}
	}
	
	private func setAttribute() {
		self.layer.cornerRadius = isRound ? self.frame.height / 2 : 8
		self.layer.borderWidth = 1
		self.buttonLabel.text = title
		if let title = self.iconTitle {
			self.buttonIcon.image = UIImage(named: title)
		} else {
			buttonIcon.isHidden = true
		}
		self.rxType.accept(type)
	}
	
	private func bind() {
		
		rxType
			.withUnretained(self)
			.subscribe(onNext: { owner, type in
				owner.configureUISet(type: type)
			})
			.disposed(by: disposeBag)
	}
	
	private func configureUISet(type: GalapagosButtonType) {
		// TODO: 여기서 색깔놀이 하자
		let UISet = type.UISet
		self.layer.borderColor = UISet.boarderColor.cgColor
		self.buttonLabel.textColor = UISet.mainColor
		self.buttonIcon.tintColor = UISet.mainColor
		self.backgroundColor = UISet.backgroundColor
		self.isUserInteractionEnabled = type.isEnable
	}
	
	public func makeCustomState(type: GalapagosButtonType) {
		rxType.accept(type)
	}
	
}

// MARK: - GalapagosButton_56.ButtonType
extension GalapagosButton{
	
	/// 버튼의 상태에 따라서
	/// `boarderColor`, `mainColor`, `backgroundColor` 를 선택한다.
	/// - Parameters:
	///   - boarderColor : 버튼의 boarderColor
	///   - mainColor : 버튼의 accessoryFillColor, textColor
	///   - backgroundColor : 버튼의 backgroundColor
	
	public enum GalapagosButtonType {
		case fill
		case outline(OutlineStyle)
		case usage(UsageStyle)
		
		public enum OutlineStyle {
			case nornal
			case bold
		}
		
		public enum UsageStyle {
			case inactive
			case disabled
			case whiteDisabled
			case softInactive
		}
		
		var isEnable: Bool {
			switch self {
			case .fill, .outline:
				return true
			case .usage(let style):
				switch style {
				case .inactive, .softInactive:
					return true
				default:
					return false
				}
			}
			
		}
		
		var UISet: GalapagosButton_56UISet {
			switch self {
			case .fill:
				return GalapagosButton_56UISet(
					boarderColor: SiriUIKitAsset.green.color,
					mainColor: SiriUIKitAsset.white기본화이트.color,
					backgroundColor: SiriUIKitAsset.green.color
				)
			case .outline(let style):
				switch style {
				case .nornal:
					return GalapagosButton_56UISet(
						boarderColor: SiriUIKitAsset.gray5DisableText2.color,
						mainColor: SiriUIKitAsset.gray1본문Body.color,
						backgroundColor: SiriUIKitAsset.white기본화이트.color
					)
				case .bold:
					return GalapagosButton_56UISet(
						boarderColor: SiriUIKitAsset.gray1본문Body.color,
						mainColor: SiriUIKitAsset.gray1본문Body.color,
						backgroundColor: SiriUIKitAsset.gray1본문Body.color
					)
				}
			case .usage(let style):
				switch style {
				case .inactive:
					return GalapagosButton_56UISet(
						boarderColor: SiriUIKitAsset.green.color,
						mainColor: SiriUIKitAsset.white기본화이트.color,
						backgroundColor: SiriUIKitAsset.green.color
					)
				case .disabled:
					return GalapagosButton_56UISet(
						boarderColor: SiriUIKitAsset.gray3DisableButtonBg.color,
						mainColor: SiriUIKitAsset.gray3DisableText1.color,
						backgroundColor: SiriUIKitAsset.gray3DisableButtonBg.color
					)
				case .whiteDisabled:
					return GalapagosButton_56UISet(
						boarderColor: SiriUIKitAsset.green.color,
						mainColor: SiriUIKitAsset.gray3DisableText1.color,
						backgroundColor: SiriUIKitAsset.white기본화이트.color
					)
				case .softInactive:
					return GalapagosButton_56UISet(
						boarderColor: SiriUIKitAsset.green.color.withAlphaComponent(0.16),
						mainColor: SiriUIKitAsset.green.color,
						backgroundColor: SiriUIKitAsset.green.color.withAlphaComponent(0.16)
					)
				}
			}
		}
	}
	
	
}

extension Reactive where Base: GalapagosButton {
	public var tap: ControlEvent<Void> {
		let source: Observable<Void> = self.base.rx.tapGesture()
			.when(.recognized)
			.map { _ in () }
		return ControlEvent(events: source)
	}
	
}
