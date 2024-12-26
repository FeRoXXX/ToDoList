//
//  CalendarView.swift
//  ToDoList
//
//  Created by Александр Федоткин on 25.12.2024.
//

import UIKit
import SnapKit
import Combine

final class CalendarView: UIView {
    
    //MARK: - Public properties
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Calendar"
        label.font = UIFont(name: Fonts.poppinsBold.rawValue, size: 18)
        label.textColor = Colors.whiteColorFirst
        return label
    }()
    
    var tasksCalendar: CustomCalendarView = {
        let calendar = CustomCalendarView()
        return calendar
    }()
    
    var tableView: CalendarTableView = {
        let tableView = CalendarTableView()
        tableView.backgroundColor = Colors.clearColor
        return tableView
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
    }
}

//MARK: - Private extension

private extension CalendarView {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(titleLabel)
        addSubview(tasksCalendar)
        addSubview(tableView)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(75)
            make.centerX.equalToSuperview()
        }
        
        tasksCalendar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(18)
            make.height.equalTo(285)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tasksCalendar.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
