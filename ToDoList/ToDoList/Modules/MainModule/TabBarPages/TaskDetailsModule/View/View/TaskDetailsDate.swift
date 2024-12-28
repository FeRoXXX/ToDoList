//
//  TaskDetailsDate.swift
//  ToDoList
//
//  Created by Александр Федоткин on 24.12.2024.
//

import UIKit
import SnapKit
import Combine

final class TaskDetailsDate: UIView {
    
    //MARK: - Public properties
    
    let dateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.TaskImages.taskDetailsDateCalendar
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.poppinsLight.rawValue, size: 14)
        label.textColor = Colors.whiteColorFirst
        label.numberOfLines = 1
        return label
    }()
    
    let verticalSeparatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = Colors.whiteColorFirst
        return separatorView
    }()
    
    let timeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.TaskImages.taskDetailsDateClock
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.poppinsLight.rawValue, size: 14)
        label.textColor = Colors.whiteColorFirst
        label.numberOfLines = 1
        return label
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

private extension TaskDetailsDate {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        backgroundColor = Colors.clearColor
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(dateImageView)
        addSubview(dateLabel)
        addSubview(verticalSeparatorView)
        addSubview(timeImageView)
        addSubview(timeLabel)
    }
    
    func setupConstraints() {
        dateImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateImageView.snp.trailing).offset(4)
            make.top.bottom.equalToSuperview()
        }
        
        verticalSeparatorView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(1)
            make.leading.equalTo(dateLabel.snp.trailing).offset(4)
        }
        
        timeImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(verticalSeparatorView.snp.trailing).offset(4)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(timeImageView.snp.trailing).offset(4)
        }
    }
}
