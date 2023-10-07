//
//  GalapagosErrorMessage.swift
//  Galapagos
//
//  Created by Siri on 2023/10/07.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit

public final class GalapagosErrorMessage: UIView {
    
    // MARK: - UI
    private lazy var errorAccessory: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = SiriUIKitFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = SiriUIKitAsset.redErrorText.color
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [errorAccessory, errorLabel])
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    //MARK: - Properties
    typealias GalapagosErrorMessageUISet = (errorMessageColor: UIColor, accessoryImage: UIImage?)

    var disposeBag = DisposeBag()
    private var title = BehaviorRelay<String>(value: "")
    private var resetState: (String, GalapagosErrorMessageType)
    
    public var rxType = BehaviorRelay<GalapagosErrorMessageType>(value: .None)
    
    // MARK: - Initialize
    
    /// ErrorMessage의 `title`을 설정합니다.
    /// - Parameters:
    ///   - title : Error의 타이틀을 설정합니다.
    ///   - type: 초기 타입을 설정합니다.
    public init(title: String, type: GalapagosErrorMessageType) {
        self.title.accept(title)
        self.rxType.accept(type)
        self.resetState = (title, type)
        super.init(frame: .zero)
        
        setAddSubView()
        setConstraint()
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    private func setAddSubView() {
        addSubview(stackView)
    }
    
    private func setConstraint() {
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        errorAccessory.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
    }
    
    private func bind() {
        rxType
            .asDriver(onErrorJustReturn: .None)
            .drive(onNext: { [weak self] type in
                self?.configureUISet(type: type)
            })
            .disposed(by: disposeBag)
        
        title
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] title in
                self?.errorLabel.text = title
            })
            .disposed(by: disposeBag)
    }
    
    private func configureUISet(type: GalapagosErrorMessageType) {
        // TODO: 여기서 색깔놀이 하자
        let UISet = type.UISet
        errorLabel.textColor = UISet.errorMessageColor
        errorAccessory.image = UISet.accessoryImage
        errorAccessory.isHidden = type == .Error ? true : false
    }
    
    public func setErrorMessage(message: String) {
        title.accept(message)
    }
    
    public func reset() {
        title.accept(resetState.0)
        rxType.accept(resetState.1)
    }
    
}

//MARK: - GalapagosErrorMessage.Type
extension GalapagosErrorMessage {
    
    /// 에러의 상태에 따라서
    /// `errorMessageColor`, `accessoryImage` 를 선택한다.
    /// - Parameters:
    ///   - errorMessageColor : 에러 라벨의 색상
    ///   - accessoryImage : 악세서리 이미지
    
    public enum GalapagosErrorMessageType {
        case Info
        case Error
        case Success
        case Disabled
        case None
        
        var UISet: GalapagosErrorMessageUISet {
            switch self {
                case .Info:
                    return (errorMessageColor: SiriUIKitAsset.gray2주석CaptionSmall힌트PlaceholderText.color,
                            accessoryImage: SiriUIKitAsset._20x20infoDefault.image)
                case .Error:
                    return (errorMessageColor: SiriUIKitAsset.redErrorText.color,
                            accessoryImage: nil)
                case .Success:
                    return (errorMessageColor: SiriUIKitAsset.green.color,
                            accessoryImage: SiriUIKitAsset._16x16checkActive.image)
                case .None:
                    return (errorMessageColor: .clear,
                            accessoryImage: nil)
                case .Disabled:
                    return (errorMessageColor: SiriUIKitAsset.gray5DisableText2.color,
                            accessoryImage: SiriUIKitAsset._16x16checkDefault.image)
                    
            }
        }
    }
    
}
