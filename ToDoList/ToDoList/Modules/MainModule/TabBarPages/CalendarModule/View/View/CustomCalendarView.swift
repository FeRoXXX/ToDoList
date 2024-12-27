//
//  CustomCalendarView.swift
//  ToDoList
//
//  Created by Александр Федоткин on 25.12.2024.
//

import UIKit
import FSCalendar
import SnapKit
import Combine

final class CustomCalendarView: FSCalendar {
    
    //MARK: - Private properties
    
    private(set) var selectedDatePublisher: PassthroughSubject<Date, Never> = PassthroughSubject()
    private var isLayerSetup: Bool = false
    
    //MARK: - Public properties
    
    var numberOfEvents: [Date] = [] {
        didSet {
            self.reloadData()
        }
    }
    
    //MARK: - Navigation buttons
    
    private lazy var previousButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = Images.NavigationImages.systemChevronLeft
        button.configuration = configuration
        button.tintColor = Colors.lightBlueSecond
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(previousButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = Images.NavigationImages.systemChevronRight
        button.configuration = configuration
        button.tintColor = Colors.lightBlueSecond
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout subviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isLayerSetup {
            let gradient = bounds.getGradientLayer(colorTop: Colors.Background.calendarBackgroundTop,
                                                   colorBottom: Colors.Background.calendarBackgroundBottom,
                                                   startPoint: CGPoint(x: 0, y: 0),
                                                   endPoint: CGPoint(x: 1, y: 1))
            layer.insertSublayer(gradient, at: 0)
            isLayerSetup = true
        }
    }
    
    func setupAllTasksDate() {
        
    }
}

//MARK: - Private extension

private extension CustomCalendarView {
    
    // MARK: - UI Configuration
    
    func setupUI() {
        appearance.selectionColor = Colors.lightBlueFourth
        appearance.titleWeekendColor = Colors.lightBlueFifth
        appearance.titleDefaultColor = Colors.whiteColorFirst
        select(.now)
        appearance.todayColor = Colors.clearColor
        appearance.headerTitleColor = Colors.whiteColorFirst
        appearance.weekdayTextColor = Colors.whiteColorFirst
        appearance.eventDefaultColor = Colors.lightBlueFifth
        appearance.eventSelectionColor = Colors.lightBlueFifth
        appearance.headerMinimumDissolvedAlpha = 0
        firstWeekday = 2
        layer.cornerRadius = 10
        layer.masksToBounds = true
        delegate = self
        dataSource = self
        
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(previousButton)
        addSubview(nextButton)
    }
    
    func setupConstraints() {
        previousButton.snp.makeConstraints { make in
            make.width.equalTo(10)
            make.height.equalTo(17)
            make.centerY.equalTo(calendarHeaderView.snp.centerY)
            make.trailing.equalTo(calendarHeaderView.snp.leading).inset(80)
        }
        
        nextButton.snp.makeConstraints { make in
            make.width.equalTo(10)
            make.height.equalTo(17)
            make.centerY.equalTo(calendarHeaderView.snp.centerY)
            make.leading.equalTo(calendarHeaderView.snp.trailing).inset(80)
        }
    }
    
    @objc
    func nextButtonAction() {
        guard let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentPage) else { return }
        self.setCurrentPage(nextMonth, animated: true)
    }
    
    @objc
    func previousButtonAction() {
        guard let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentPage) else { return }
        self.setCurrentPage(previousMonth, animated: true)
    }
}

//MARK: - FSCalendarDelegate & FSCalendarDataSource

extension CustomCalendarView: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDatePublisher.send(date)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let calendar = Calendar.current
        let events = numberOfEvents.filter { calendar.isDate($0, inSameDayAs: date) }.prefix(2)
        return events.count
    }
}
