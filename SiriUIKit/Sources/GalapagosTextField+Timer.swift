//
//  GalapagosTextField+Timer.swift
//  SiriUIKit
//
//  Created by 조용인 on 2023/07/04.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit

public final class GalapagosTextField_Timer: UIView {
    
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
        textField.keyboardType = .default
        textField.font = SiriUIKitFontFamily.Pretendard.medium.font(size: 18)
        textField.textColor = SiriUIKitAsset.black제목DisplayHeadingBody.color
        return textField
    }()
    
    private lazy var certifyButton: GalapagosButton = {
        let button = GalapagosButton(isRound: false,
                                     iconTitle: nil,
                                     type: .Usage(.Disabled),
                                     title: "확인")
        return button
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = SiriUIKitAsset.green.color
        label.font = SiriUIKitFontFamily.Pretendard.medium.font(size: 16)
        return label
    }()
    
    private lazy var errorMessagelabel: UILabel = {
        let label = UILabel()
        label.text = errorMessage
        label.textColor = SiriUIKitAsset.redErrorText.color
        label.semanticContentAttribute = .forceLeftToRight
        label.font = SiriUIKitFontFamily.Pretendard.regular.font(size: 12)
        return label
    }()
    
    // MARK: - Properties
    typealias TextFieldWithTimerUISet = (borderColor: UIColor, textFieldBackgroundColor: UIColor, textFieldTextColor: UIColor, errorMessageHidden: Bool, isUserInteractive: Bool)
    
    private var disposeBag = DisposeBag()
    private var timerDisposeBag = DisposeBag()
    
    private var placeHolder: String
    private var maxCount: Int
    private var errorMessage: String
    
    /// 차후에 커스텀으로 사용 할 일 있으면, 변수로 빼자
    
    private var timerCountRelay = BehaviorRelay<Int>(value: 180)
    public var rxType = BehaviorRelay<TextFieldWithTimerType>(value: .disabled)
    public var resetTimerSubject = PublishSubject<Void>()
    
    /// 텍스트필드의 `placeHolder`, `maxCount`, `errorMessage`를 설정합니다.
    /// - Parameters:
    ///   - placeHolder : placeHolder로 들어갈 텍스트
    ///   - maxCount : 최대 입력 가능한 글자 수 ( 0이면, 제한 없음 )
    ///   - errorMessage : error상황에 따른 메세지 (ex: 이메일 형식이 아닙니다.)
    /// - Parameters (Optional):
    // MARK: - Initializers
    public init(
        placeHolder: String,
        maxCount: Int,
        errorMessage: String
    ) {
        self.placeHolder = placeHolder
        self.maxCount = maxCount
        self.errorMessage = errorMessage
        
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
        self.addSubview(certifyButton)
        self.addSubview(timerLabel)
        self.addSubview(errorMessagelabel)
    }
    
    private func setConstraint() {
        
        textField.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(68)
        }
        
        certifyButton.snp.makeConstraints {
            $0.centerY.equalTo(textField)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.bottom.equalTo(textField).GalapagosInset(inset: ._12)
            $0.width.equalTo(49)
        }
        
        timerLabel.snp.makeConstraints {
            $0.centerY.equalTo(textField)
            $0.trailing.equalTo(certifyButton.snp.leading).offset(-10)
            $0.height.equalTo(24)
            $0.width.equalTo(44)
        }
        
        errorMessagelabel.snp.makeConstraints {
            $0.centerY.equalTo(textField)
            $0.trailing.equalTo(certifyButton.snp.leading).offset(-10)
            $0.height.equalTo(24)
            $0.width.equalTo(44)
        }
        
    }
    
    private func bind() {
        
        resetTimerSubject
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.resetTimer()
            })
            .disposed(by: disposeBag)
        
        rxType
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .def)
            .drive(onNext: { [weak self] type in
                guard let self = self else { return }
                let isTimerOn = (type != .error && type != .disabled)
                self.controlTimer(isOn: isTimerOn)
            })
            .disposed(by: disposeBag)
        
        rxType
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .def)
            .drive(onNext: { [weak self] type in
                guard let self = self else { return }
                self.configureColorSet(type: type)
            })
            .disposed(by: disposeBag)

        textField.rx.text.orEmpty
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] text in
                guard let self = self else { return }
                text.count == self.maxCount
                ? self.certifyButton.makeCustomState(type: .Usage(.Inactive))
                : self.certifyButton.makeCustomState(type: .Usage(.Disabled))
            })
            .disposed(by: disposeBag)
        
    }
    
    private func configureColorSet(type: TextFieldWithTimerType) {
        // TODO: 여기서 색깔놀이 하자
        let UISet = type.UISet
        textField.layer.borderColor = UISet.borderColor.cgColor
        textField.backgroundColor = UISet.textFieldBackgroundColor
        textField.textColor = UISet.textFieldTextColor
        errorMessagelabel.isHidden = UISet.errorMessageHidden
        timerLabel.textColor = type.timerColor
        self.isUserInteractionEnabled = UISet.isUserInteractive
        
    }
    
    func makeCustomState(textFieldWithTimerState: TextFieldWithTimerType) {
        rxType.accept(textFieldWithTimerState)
    }
    
    private func startTimer() {
        timerDisposeBag = DisposeBag() // 이전 타이머 구독 해제
        
        Observable<Int>
            .timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
            .debug()
            .withLatestFrom(timerCountRelay.asObservable()) { _, count in count }
            .map { $0 - 1 }
            .do(onNext: { [weak self] newCount in
                self?.timerCountRelay.accept(newCount)
            })
            .take(while: {  $0 >= 0 })
            .map { timeInSeconds -> String in
                let minutes = timeInSeconds / 60
                let seconds = timeInSeconds % 60
                return String(format: "%02d:%02d", minutes, seconds)
            }
            .debug()
            .asDriver(onErrorJustReturn: "Error")
            .drive(timerLabel.rx.text)
            .disposed(by: timerDisposeBag)
    }
    
    private func resetTimer() {
        timerCountRelay.accept(180)  // 초기 시간을 180초로 설정
        startTimer()                 // 타이머 다시 시작
    }

    private func controlTimer(isOn: Bool) {
        if isOn {
            startTimer()
        } else {
            timerDisposeBag = DisposeBag() // 타이머 구독 해제
        }
    }


}


extension GalapagosTextField_Timer{
    
    /// TextField의 상태에 따라서
    /// `Boarder color`, `textField background color`, `textField text color`,
    /// `errorMessage Hidden`, `isUserInteractive` 를 선택한다.
    /// - Parameters:
    ///   - BorderColor : TextField의 border color 색상
    ///   - textFieldBackgroundColor : TextField의 background color 색상
    ///   - textFieldTextColor : TextField의 text  color 색상
    ///   - errorMessageHidden : errorMessage의 hidden 여부
    ///   - isUserInteractive : TextField의 isUserInteractive
    
    
    public enum TextFieldWithTimerType {
        case def /// 초기 상태
        case focus /// 입력 중
        case filed /// 입력 완료
        case disabled /// 불가영역
        case error /// 에러

        var timerColor: UIColor {
            switch self {
                case .def:
                    return SiriUIKitAsset.white기본화이트.color
                case .focus:
                    return SiriUIKitAsset.green.color
                case .filed:
                    return SiriUIKitAsset.green.color
                case .disabled:
                    return SiriUIKitAsset.gray3DisableButtonBg.color
                case .error:
                    return SiriUIKitAsset.redErrorText.color
            }
        }
        
        
        
        var UISet: TextFieldWithTimerUISet {
            switch self {
                case .def:
                    return TextFieldWithTimerUISet(
                        borderColor: SiriUIKitAsset.gray1Outline.color,
                        textFieldBackgroundColor: SiriUIKitAsset.white기본화이트.color,
                        textFieldTextColor: SiriUIKitAsset.gray1본문Body.color,
                        errorMessageHidden: true,
                        isUserInteractive: true
                    )
                case .focus:
                    return TextFieldWithTimerUISet(
                        borderColor: SiriUIKitAsset.green.color,
                        textFieldBackgroundColor: SiriUIKitAsset.white기본화이트.color,
                        textFieldTextColor: SiriUIKitAsset.gray1본문Body.color,
                        errorMessageHidden: true,
                        isUserInteractive: true
                    )
                case .filed:
                    return TextFieldWithTimerUISet(
                        borderColor: SiriUIKitAsset.gray1Outline.color,
                        textFieldBackgroundColor: SiriUIKitAsset.white기본화이트.color,
                        textFieldTextColor: SiriUIKitAsset.gray1본문Body.color,
                        errorMessageHidden: true,
                        isUserInteractive: true
                    )
                case .disabled:
                    return TextFieldWithTimerUISet(
                        borderColor: SiriUIKitAsset.gray3DisableButtonBg.color,
                        textFieldBackgroundColor: SiriUIKitAsset.gray3DisableButtonBg.color,
                        textFieldTextColor: SiriUIKitAsset.gray5DisableText2.color,
                        errorMessageHidden: true,
                        isUserInteractive: false
                    )
                case .error:
                    return TextFieldWithTimerUISet(
                        borderColor: SiriUIKitAsset.redErrorText.color,
                        textFieldBackgroundColor: SiriUIKitAsset.white기본화이트.color,
                        textFieldTextColor: SiriUIKitAsset.gray1본문Body.color,
                        errorMessageHidden: false,
                        isUserInteractive: true
                    )
                    
            }
        }
    }
    
}


extension GalapagosTextField_Timer: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return maxCount == 0 ? true : newLength <= maxCount
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.rxType.accept(.focus)
        return true
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.rxType.accept(.filed)
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.rxType.accept(.filed)
        return true
    }
}


//MARK: - GalapagosTextField+RxSwift
extension Reactive where Base: GalapagosTextField_Timer {
    
    public func controlEvent(_ events: UIControl.Event) -> ControlEvent<Void> {
        let source = self.base.textField.rx.controlEvent(events).map { _ in }
        return ControlEvent(events: source)
    }
    
    public var text: ControlProperty<String?> {
        return self.base.textField.rx.text
    }
    
    public var becomeFirstResponder: Binder<Void> {
        return Binder(self.base) { textField, _ in
            textField.textField.becomeFirstResponder()
        }
    }
    
}
