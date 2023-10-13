//
//  TermsAndConditionsViewModel.swift
//  Galapagos
//
//  Created by Siri on 2023/10/02.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//
import Foundation

import RxCocoa
import RxSwift

import UIKit

final class TermsAndConditionsViewModel: ViewModelType {
	
	struct Input {
		let allAgreeBtnTapped: Observable<Void>
		let termsBtnTapped: Observable<Void>
		let conditionBtnTapped: Observable<Void>
		let eventBtnTapped: Observable<Void>
	}
	
	struct Output {
		let allAgreeBtnState: Observable<Bool>
		let termsBtnState: Observable<Bool>
		let conditionBtnState: Observable<Bool>
		let eventBtnState: Observable<Bool>
		
		let moveToNext: Observable<Bool>
	}
	
	var disposeBag: DisposeBag = DisposeBag()
	
	private var allAgreeBtnRelay = BehaviorRelay<Bool>(value: false)
	private var termsBtnRelay = BehaviorRelay<Bool>(value: false)
	private var conditionBtnRelay = BehaviorRelay<Bool>(value: false)
	private var eventBtnRelay = BehaviorRelay<Bool>(value: false)
	
	func transform(input: Input) -> Output {
		input.termsBtnTapped.bind { [unowned self] in
			termsBtnRelay.accept(!termsBtnRelay.value)
			updateAllAgreeState()
		}.disposed(by: disposeBag)
		
		input.conditionBtnTapped.bind { [unowned self] in
			conditionBtnRelay.accept(!conditionBtnRelay.value)
			updateAllAgreeState()
		}.disposed(by: disposeBag)
		
		input.eventBtnTapped.bind { [unowned self] in
			eventBtnRelay.accept(!eventBtnRelay.value)
			updateAllAgreeState()
		}.disposed(by: disposeBag)
		
		input.allAgreeBtnTapped.bind { [unowned self] in
			let newState = !allAgreeBtnRelay.value
			allAgreeBtnRelay.accept(newState)
			termsBtnRelay.accept(newState)
			conditionBtnRelay.accept(newState)
			eventBtnRelay.accept(newState)
		}.disposed(by: disposeBag)
		
		let moveToNext = Observable.combineLatest(termsBtnRelay, conditionBtnRelay)
			.map { $0 && $1 }
		
		return Output(
			allAgreeBtnState: allAgreeBtnRelay.asObservable(),
			termsBtnState: termsBtnRelay.asObservable(),
			conditionBtnState: conditionBtnRelay.asObservable(),
			eventBtnState: eventBtnRelay.asObservable(),
			moveToNext: moveToNext
		)
	}
	
}

// MARK: - Private Methods
extension TermsAndConditionsViewModel {
	
	private func updateAllAgreeState() {
		let allSelected = termsBtnRelay.value && conditionBtnRelay.value && eventBtnRelay.value
		allAgreeBtnRelay.accept(allSelected)
	}
}
