//
//  GalapagosTextField.swift
//  SiriUIKit
//
//  Created by 조용인 on 2023/06/29.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//
import Foundation

import RxCocoa
import RxSwift

import SnapKit

import UIKit

public final class GalapagosTextField: UIView{
	
	// MARK: - UI
	fileprivate lazy var textField: UITextField = {
		let textField = UITextField()
		let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
		let rightPadding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
		textField.leftView = leftPadding
		textField.rightView = rightPadding
		textField.leftViewMode = .always
		textField.rightViewMode = .always
		textField.placeholder = placeHolder
		textField.layer.cornerRadius = 8
		textField.layer.borderWidth = 1
		textField.keyboardType = keyboardType
		textField.font = SiriUIKitFontFamily.Pretendard.medium.font(size: 18)
		textField.textColor = SiriUIKitAsset.black제목DisplayHeadingBody.color
		return textField
	}()
	
	private lazy var charCountLabel: UILabel = {
		let label = UILabel()
		label.font = SiriUIKitFontFamily.Pretendard.medium.font(size: 14)
		label.text = "0/\(maxCount)"
		label.textColor = SiriUIKitAsset.gray5DisableText2.color
		return label
	}()
	
	private lazy var clearButton: UIButton = {
		let button = UIButton()
		button.setImage(SiriUIKitAsset._24x24cancleRoundDefault.image, for: .normal)
		return button
	}()
	
	// MARK: - Properties
	typealias TextFieldColorSet = (
		borderColor: UIColor,
		textFieldBackgroundColor: UIColor,
		textFieldTextColor: UIColor,
		charCountHidden: Bool, clearMode: Bool,
		isUserInteractive: Bool
	)
	
	private var disposeBag = DisposeBag()
	
	private var placeHolder: String
	private var maxCount: Int
	
	private var keyboardType: UIKeyboardType = .emailAddress
	private var clearMode: Bool = false
	
	public var rxType = BehaviorRelay<TextFieldType>(value: .def)
	public var text: String? {
		get {
			return textField.text
		}
		set {
			textField.text = newValue
		}
	}
	public var isSecureTextEntry: Bool {
		get {
			return textField.isSecureTextEntry
		}
		set {
			textField.isSecureTextEntry = newValue
		}
	}
	
	/// 텍스트필드의 `placeHolder`, `maxCount`를 설정합니다.
	/// - Parameters:
	///   - placeHolder : placeHolder로 들어갈 텍스트
	///   - maxCount : 최대 입력 가능한 글자 수 ( 0이면, 제한 없음 )
	/// - Parameters (Optional):
	///   - keyboardType : 키보드 타입
	///   - clearMode : clear 버튼 On Off
	/// - Parameters (Accessable):
	///   - text: textField의 text값
	///   - isSecureTextEntry: 텍스트 숨김 여부
	///   - rxType: GalapagosTextField의 타입변환 조종값
	// MARK: - Initializers
	public init(
		placeHolder: String,
		maxCount: Int
	) {
		self.placeHolder = placeHolder
		self.maxCount = maxCount
		
		super.init(frame: .zero)
		
		textField.delegate = self
		
		setAddSubView()
		setConstraint()
		bind()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	// MARK: - LifeCycle
	
	// MARK: - Methods
	
	private func setAddSubView() {
		self.addSubview(textField)
		self.addSubview(charCountLabel)
		self.addSubview(clearButton)
	}
	
	private func setConstraint() {
		
		textField.snp.makeConstraints {
			$0.top.leading.trailing.equalToSuperview()
			$0.height.equalTo(68)
		}
		
		clearButton.snp.makeConstraints {
			$0.centerY.equalTo(textField)
			$0.trailing.equalTo(textField).offset(-20)
			$0.width.height.equalTo(24)
		}
		
		charCountLabel.snp.makeConstraints {
			$0.centerY.equalTo(textField)
			$0.trailing.equalTo(clearButton.snp.leading).offset(-6)
			$0.height.equalTo(22)
		}
	}
	
	private func bind() {
		
		rxType
			.distinctUntilChanged()
			.asDriver(onErrorJustReturn: .def)
			.drive(onNext: { [weak self] colorSet in
				guard let self = self else { return }
				self.configureColorSet(colorSet: colorSet.colorSet)
			})
			.disposed(by: disposeBag)
		
		textField.rx.text
			.withUnretained(self)
			.map { owner, text in
				"\(text?.count ?? 0)/\(owner.maxCount)"
			}
			.bind(to: charCountLabel.rx.text)
			.disposed(by: disposeBag)
		
		clearButton.rx.tap
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.textField.text = ""
				owner.textField.sendActions(for: .editingChanged)
				if owner.rxType.value != .focus { owner.rxType.accept(.def) }
			})
			.disposed(by: disposeBag)
	}
	
	private func configureColorSet(colorSet: TextFieldColorSet) {
		// TODO: 여기서 색깔놀이 하자
		textField.layer.borderColor = colorSet.borderColor.cgColor
		textField.backgroundColor = colorSet.textFieldBackgroundColor
		textField.textColor = colorSet.textFieldTextColor
		charCountLabel.isHidden = colorSet.charCountHidden
		clearButton.isHidden = !colorSet.clearMode
		self.isUserInteractionEnabled = colorSet.isUserInteractive
		
		if maxCount == 0 {
			charCountLabel.isHidden = true
		}
	}
	
	func makeCustomState(textFieldState: TextFieldType) {
		rxType.accept(textFieldState)
	}
}

extension GalapagosTextField{
	
	/// TextField의 상태에 따라서
	/// `Boarder color`, `textField background color`, `textField text attribute color`, `errorMessage Hidden`,
	/// `charCount hidden`, `clearMode`, `isUserInteractive` 를 선택한다.
	/// - Parameters:
	///   - BorderColor : TextField의 border color 색상
	///   - textFieldBackgroundColor : TextField의 background color 색상
	///   - textFieldTextColor : TextField의 text  color 색상
	///   - errorMessageHidden : errorMessage의 hidden 여부
	///   - charCountHidden : charCount의 hidden 여부
	///   - clearMode : TextField의 clearMode
	///   - isUserInteractive : TextField의 isUserInteractive
	
	
	public enum TextFieldType {
		case def /// 초기 상태
		case focus /// 입력 중
		case filed /// 입력 완료
		case disabled /// 불가영역
		case error /// 에러
		
		var colorSet: TextFieldColorSet {
			switch self {
			case .def:
				return TextFieldColorSet(
					borderColor: SiriUIKitAsset.gray1Outline.color,
					textFieldBackgroundColor: SiriUIKitAsset.white기본화이트.color,
					textFieldTextColor: SiriUIKitAsset.gray1본문Body.color,
					charCountHidden: true,
					clearMode: false,
					isUserInteractive: true
				)
			case .focus:
				return TextFieldColorSet(
					borderColor: SiriUIKitAsset.green.color,
					textFieldBackgroundColor: SiriUIKitAsset.white기본화이트.color,
					textFieldTextColor: SiriUIKitAsset.gray1본문Body.color,
					charCountHidden: false,
					clearMode: true,
					isUserInteractive: true
				)
			case .filed:
				return TextFieldColorSet(
					borderColor: SiriUIKitAsset.gray1Outline.color,
					textFieldBackgroundColor: SiriUIKitAsset.white기본화이트.color,
					textFieldTextColor: SiriUIKitAsset.gray1본문Body.color,
					charCountHidden: true,
					clearMode: true,
					isUserInteractive: true
				)
			case .disabled:
				return TextFieldColorSet(
					borderColor: SiriUIKitAsset.gray3DisableButtonBg.color,
					textFieldBackgroundColor: SiriUIKitAsset.gray3DisableButtonBg.color,
					textFieldTextColor: SiriUIKitAsset.gray5DisableText2.color,
					charCountHidden: true,
					clearMode: false,
					isUserInteractive: false
				)
			case .error:
				return TextFieldColorSet(
					borderColor: SiriUIKitAsset.redErrorText.color,
					textFieldBackgroundColor: SiriUIKitAsset.white기본화이트.color,
					textFieldTextColor: SiriUIKitAsset.gray1본문Body.color,
					charCountHidden: true,
					clearMode: true,
					isUserInteractive: true
				)
				
			}
		}
	}
	
}


extension GalapagosTextField: UITextFieldDelegate {
	
	public func textField(
		_ textField: UITextField,
		shouldChangeCharactersIn range: NSRange,
		replacementString string: String
	) -> Bool {
		guard let text = textField.text else { return true }
		let newLength = text.count + string.count - range.length
		return maxCount == 0 ? true : newLength <= maxCount
	}
	
	public func textFieldShouldClear(_ textField: UITextField) -> Bool {
		self.rxType.accept(.focus)
		return true
	}
	
	public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		self.rxType.accept(.focus)
		return true
	}
	
	public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		guard let text = textField.text else { return false }
		if text.isEmpty {
			self.rxType.accept(.def)
		} else {
			self.rxType.accept(.filed)
		}
		return true
	}
	
	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		guard let text = textField.text else { return false }
		if text.isEmpty {
			self.rxType.accept(.def)
		} else {
			self.rxType.accept(.filed)
		}
		return true
	}
}


// MARK: - GalapagosTextField+RxSwift
extension Reactive where Base: GalapagosTextField {
	
	public func controlEvent(_ events: UIControl.Event) -> ControlEvent<Void> {
		let source = self.base.textField.rx.controlEvent(events).map { _ in }
		return ControlEvent(events: source)
	}
	
	public var text: ControlProperty<String?> {
		return self.base.textField.rx.text
	}
	
}
