//
//  GalapagosCalendarViewController.swift
//  Galapagos
//
//  Created by 박혜운 on 2023/08/06.
//  Copyright © 2023 com.busyModernPeople. All rights reserved.
//

import UIKit

final class CalendarViewController: UIViewController {
  
  // MARK: - UI
  
  private lazy var contentView = {
    let view = UIView()
    view.layoutMargins = .zero
    view.backgroundColor = .white
    return view
  }()
  
  private lazy var headerContainView = {
    let view = UIView()
    view.layoutMargins = .zero
    return view
  }()
  
  private lazy var titleLabel = {
    let label = UILabel()
    label.text = "2000년 01월"
    label.font = GalapagosFontFamily.Pretendard.bold.font(size: 20)
    return label
  }()
  
  private lazy var previousButton = {
    let button = UIButton()
    button.setImage(GalapagosAsset._20x20arrowLeft.image, for: .normal)
    button.addTarget(self, action: #selector(self.didPreviousButtonTouched), for: .touchUpInside)
    return button
  }()
  
  private lazy var nextButton = {
    let button = UIButton()
    button.setImage(GalapagosAsset._20x20arrowRight.image, for: .normal)
    button.addTarget(self, action: #selector(self.didNextButtonTouched), for: .touchUpInside)
    return button
  }()
  
  private lazy var weekStackView = {
    let stackView = UIStackView()
    stackView.distribution = .fillEqually
    let dayOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
    
    for i in 0..<7 {
      let label = UILabel()
      label.text = dayOfTheWeek[i]
      label.font = GalapagosFontFamily.Pretendard.semiBold.font(size: 14)
      label.textColor = GalapagosAsset.gray2주석CaptionSmall힌트PlaceholderText.color
      label.textAlignment = .center
      stackView.addArrangedSubview(label)
    }
    return stackView
  }()
  
  private lazy var collectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.delegate = self
    collectionView.register(
      CalendarCollectionViewCell.self,
      forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier
    )
    collectionView.layoutMargins = .zero
    collectionView.allowsMultipleSelection = false
    return collectionView
  }()
  
  // MARK: - Private Properties
  
  private enum Section {
    case main
  }
  private struct Item: Hashable {
    let day: String
    let isToday: Bool
    var hasEvent: Bool
    let identifier = UUID()
  }
  
  private var calendarDate: Date {
    didSet {
      self.calendarDate.test()
    }
  } // calendarDate 변경 메서드 🔥
  private var events: [String]
  private var cellRegistration = UICollectionView
    .CellRegistration<CalendarCollectionViewCell, Item> {
      (cell, indexPath, item) in
      cell.configure(
        day: item.day,
        hasEvent: item.hasEvent,
        isToday: item.isToday
      )
    }
  private var initialContentOffset: CGFloat = 0
  private lazy var dataSource = makeCellDataSource()// 메서드로 따로 빼기
  
  // MARK: - Initializers
  init(
    calendarDate: Date = Date(),
    events: [String] = []
  ) {
    self.calendarDate = calendarDate
    self.events = events
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .clear
    self.setAddSubView()
    self.setAddSwipeGesture()
    self.setConstraint()
    self.setCollectionDataSource()
    self.updateCalendar(to: self.calendarDate)
    self.adjustFlowLayoutSpacing() // 수평 간격 0
  }
  
  // MARK: - Methods
  private func setAddSwipeGesture() {
    let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
    self.contentView.addGestureRecognizer(swipeGesture)
  }
  
  private func setAddSubView() {
    self.view.addSubview(self.contentView)
    self.contentView.addSubview(self.headerContainView)
    self.contentView.addSubview(self.weekStackView)
    self.contentView.addSubview(self.collectionView)
    headerContainView.addSubview(self.titleLabel)
    headerContainView.addSubview(self.previousButton)
    headerContainView.addSubview(self.nextButton)
  }
  
  private func setConstraint() {
    self.contentView.snp.makeConstraints { make in
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
      make.leading.equalTo(self.view.snp.leading)
      make.trailing.equalTo(self.view.snp.trailing)
      make.width.equalTo(self.view.snp.width)
    }
    
    self.headerContainView.snp.makeConstraints { make in
      make.top.equalTo(self.contentView.snp.top)
      make.leading.equalTo(self.view.snp.leading)
      make.trailing.equalTo(self.view.snp.trailing)
      make.height.equalTo(28)
    }
    
    self.titleLabel.snp.makeConstraints { make in
      make.centerY.equalTo(self.headerContainView.snp.centerY)
      make.centerX.equalTo(self.headerContainView.snp.centerX)
    }
    
    self.previousButton.snp.makeConstraints { make in
      make.centerY.equalTo(self.headerContainView.snp.centerY)
      make.trailing.equalTo(self.titleLabel.snp.leading).offset(-14)
    }
    
    self.nextButton.snp.makeConstraints { make in
      make.centerY.equalTo(self.headerContainView.snp.centerY)
      make.leading.equalTo(self.titleLabel.snp.trailing).offset(14)
    }
    
    self.weekStackView.snp.makeConstraints { make in
      make.top.equalTo(self.headerContainView.snp.bottom).offset(20)
      make.leading.equalTo(self.contentView.snp.leading)
      make.trailing.equalTo(self.contentView.snp.trailing)
      //      make.height.equalTo(42)
      make.height.equalTo(self.contentView.snp.width).multipliedBy(1.0 / 7.0)
    }
    
    self.collectionView.snp.makeConstraints { make in
      make.top.equalTo(self.weekStackView.snp.bottom)
      make.leading.equalTo(self.weekStackView.snp.leading)
      make.trailing.equalTo(self.weekStackView.snp.trailing)
      make.bottom.equalTo(self.contentView.snp.bottom)
      make.height.equalTo(self.contentView.snp.width).multipliedBy(6.0 / 7.0)
    }
  }
  
  private func adjustFlowLayoutSpacing() {
    if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      flowLayout.minimumInteritemSpacing = 0
    }
  }
  
  // MARK: - CollectionView : DateSource
  
  private func makeCellDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
    return UICollectionViewDiffableDataSource<Section, Item>(collectionView: self.collectionView) {
      (collectionView, indexPath, item) -> UICollectionViewCell? in
      return collectionView
        .dequeueConfiguredReusableCell(
          using: self.cellRegistration,
          for: indexPath,
          item: item
        )
    }
  }
  
  private func setCollectionDataSource() {
    collectionView.dataSource = dataSource
  }
  private func applySnapshot(to date: Date) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    snapshot.appendSections([Section.main]) // 섹션 추가
    
    let cellDays = self.calendarDaysCell(date: date)
    let items = cellDays.map {
      Item(
        day: $0,
        isToday: isToday(yearMonth: date.yearMonthTitle(), day: $0),
        hasEvent: checkEventDay(calendarDate: date, day: $0))
    } // 아이템 추가
    
    snapshot.appendItems(items, toSection: Section.main) // 스냅샷 적용
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  private func isToday(yearMonth: String, day: String) -> Bool {
    guard let nowDay = Int(Date.now.day()) else { return false }
    guard yearMonth == Date.now.yearMonthTitle() && day == String(nowDay) else { return false }
    return true
  }
}


// MARK: - CollectionView : UICollectionViewDelegateFlowLayout
extension CalendarViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let availableWidth = self.view.frame.width
    let numberOfItemsPerRow: CGFloat = 7
    let spacing: CGFloat = 6 // 셀 사이의 간격
    let itemWidth = (
      availableWidth - (spacing * (numberOfItemsPerRow - 1))
    ) / numberOfItemsPerRow
    let itemHeight = itemWidth // 가로와 세로 길이가 같도록 설정
    return CGSize(width: itemWidth, height: itemHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell else {
      return UICollectionViewCell()
    }
    cell.contentView.layoutMargins = UIEdgeInsets.zero
    return cell
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 6
  }
}


// MARK: - CollectionView : UICollectionViewDelegate
extension CalendarViewController: UICollectionViewDelegate {
  
  func collectionView(
    _ collectionView: UICollectionView,
    shouldSelectItemAt indexPath: IndexPath
  ) -> Bool {
    return self.calendarDaysCell(
      date: self.calendarDate
    )[indexPath.item] != "" ? true : false // day가 없는 빈 cell은 아예 선택 불가
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell
    else { return }
    guard let day = Int(cell.day) else { return }
    self.calendarDate = self.calendarDate.setday(day) // 🔥사용자에 의해 선택되었을 때 일자 변경
  }
}


// MARK: - Calendar Logic
extension CalendarViewController {
  
  private func minusMonth() {
    let day: Int = Int(Date.now.day()) ?? 1
    var changeDate = calendarDate.minusMonth()
    changeDate = changeDate.setday(
      changeDate.compareYearMonth(Date.now) ? day : 1
    )
    self.calendarDate = changeDate // 🔥변경
    self.updateCalendar(to: self.calendarDate)
  }
  
  private func plusMonth() {
    let day: Int = Int(Date.now.day()) ?? 1
    var changeDate = calendarDate.plusMonth()
    changeDate = changeDate.setday(
      changeDate.compareYearMonth(Date.now) ? day : 1
    )
    self.calendarDate = changeDate // 🔥변경
    self.updateCalendar(to: self.calendarDate)
  }
  
  private func updateCalendar(to date: Date) { // 변경 사항 적용
    self.updateTitle(to: date)
    self.applySnapshot(to: date)
    self.updateSelectedCell(date: date, day: date.day())
  }
  
  private func updateTitle(to date: Date) {
    self.titleLabel.text = date.yearMonthTitle()
  }
  
  private func calendarDaysCell(date: Date) -> [String] {
    var cellDays: [String] = []
    cellDays.removeAll()
    let startDayOfTheWeek = date.startDayOfTheWeek()
    let totalDays = startDayOfTheWeek + date.endDate()
    
    for day in 0..<totalDays {
      if day < startDayOfTheWeek {
        cellDays.append(String())
        continue
      }
      cellDays.append("\(day - startDayOfTheWeek + 1)")
    }
    
    return cellDays
  }
  
  private func checkEventDay(calendarDate: Date, day: String) -> Bool { // 날짜가 어떻게 들어올 지 몰라서 대충 만들었습니당
    let calendar = Calendar.current
    let currentYear = calendar.component(.year, from: calendarDate)
    let currentMonth = calendar.component(.month, from: calendarDate)
    let paddedYear = String(format: "%02d", currentYear)
    let paddedMonth = String(format: "%02d", currentMonth)
    guard let day = Int(day) else { return false }
    let paddedDay = String(format: "%02d", day)
    let cellDateString: String = "\(paddedYear)-\(paddedMonth)-\(paddedDay)"
    return self.events.contains(cellDateString)
  }
  
  private func updateSelectedCell(date: Date, day: String) {
    guard let index = self.calendarDaysCell(date: date).firstIndex(of: day) else { return }
    let indexPath = IndexPath(item: index, section: 0)
    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
  }
}


// MARK: - Calendar Actions
extension CalendarViewController {
  @objc private func didPreviousButtonTouched(_ sender: UIButton) {
    self.minusMonth()
  }
  
  @objc private func didNextButtonTouched(_ sender: UIButton) {
    self.plusMonth()
  }
  
  @objc private func handleSwipeGesture(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: self.contentView)
    
    switch gesture.state {
    case .began:
      initialContentOffset = collectionView.contentOffset.x
    case .changed:
      let offsetX = initialContentOffset - translation.x
      collectionView.contentOffset.x = offsetX
    case .ended, .cancelled:
      let screenWidth = collectionView.bounds.width / 4
      let swipeDirection = collectionView.contentOffset.x - initialContentOffset
      let targetContentOffset = CGPoint(x: 0, y: collectionView.contentOffset.y)
      
      UIView.animate(withDuration: 0.3, animations: {
        self.collectionView.contentOffset = targetContentOffset
      })
      
      guard abs(swipeDirection) > screenWidth else { break }
      
      DispatchQueue.main.asyncAfter(deadline: .now()) {
        if swipeDirection < 0 {
          self.minusMonth()
        } else {
          self.plusMonth()
        }
      }
    default:
      break
    }
  }
}


extension Date { // 전부 순수함수
  fileprivate func startDayOfTheWeek() -> Int {
    let startWeekday = 1 // 일요일이 시작
    let firstDayOfMonth = Calendar.current.date(
      from: Calendar.current.dateComponents(
        [.year, .month],
        from: Calendar.current.startOfDay(for: self)
      )
    )!
    let weekday = Calendar.current.component(.weekday, from: firstDayOfMonth)
    let relativeWeekday = weekday - startWeekday // 주의 시작 요일을 기준으로 상대적인 요일을 계산
    
    return relativeWeekday < 0 ? relativeWeekday + 7 : relativeWeekday
  } // 해당 연, 월 시작요일 반환 (1이 일요일)
  
  fileprivate func endDate() -> Int {
    return Calendar.current.range(of: .day, in: .month, for: self)?.count ?? Int()
  } // 해당 연, 월의 마지막 날짜 반환
  
  fileprivate func minusMonth() -> Date {
    return Calendar.current.date(byAdding: DateComponents(month: -1), to: self) ?? Date()
  } // 이전 달로 이동한 Date 반환
  
  fileprivate func plusMonth() -> Date {
    return Calendar.current.date(byAdding: DateComponents(month: +1), to: self) ?? Date()
  } // 이후 달로 이동한 Date 반환
  
  fileprivate func compareYearMonth(_ date: Date) -> Bool{
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMM"
    return formatter.string(from: self) == formatter.string(from: date)
  } // self와 date가 같은 연, 월인지 비교
  
  fileprivate func setday(_ newDay: Int) -> Date {
    let calendar = Calendar.current
    let currentYear = calendar.component(.year, from: self) // 연
    let currentMonth = calendar.component(.month, from: self) // 월은 유지하고
    
    var dateComponents = DateComponents()
    dateComponents.year = currentYear
    dateComponents.month = currentMonth
    dateComponents.day = newDay // 일자만 변경
    
    return calendar.date(from: dateComponents) ?? Date()
  } // 같은 연, 월에 날짜만 변경한 Date 반환
  
  fileprivate func yearMonthTitle() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 MM월"
    return formatter.string(from: self)
  } // self의 yearMonthTitle 반환
  
  fileprivate func day() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "d"
    return formatter.string(from: self)
  } // self의 날짜 반환
  
  fileprivate func test() { // 삭제 예정
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd"
    print(formatter.string(from: self))
  } // date "yyyyMMdd" 형태로 print
}
