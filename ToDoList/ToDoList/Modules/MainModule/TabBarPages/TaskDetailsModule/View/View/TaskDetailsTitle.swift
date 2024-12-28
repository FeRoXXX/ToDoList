//
//  TaskDetailsTitle.swift
//  ToDoList
//
//  Created by Александр Федоткин on 24.12.2024.
//

import UIKit
import SnapKit
import Combine

final class TaskDetailsTitle: UIView {
    
    //MARK: - Private properties
    
    private(set) var taskCorrectButtonDidTapped: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    //MARK: - Public properties
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.poppinsMedium.rawValue, size: 18)
        label.textColor = Colors.whiteColorFirst
        label.numberOfLines = 2
        return label
    }()
    
    lazy var taskCorrectButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = Images.TaskImages.taskDetailsTitle
        button.configuration = configuration
        button.addTarget(self, action: #selector(taskCorrectButtonAction), for: .touchUpInside)
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
    }
}

//MARK: - Private extension

private extension TaskDetailsTitle {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        backgroundColor = Colors.clearColor
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(titleLabel)
        addSubview(taskCorrectButton)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        taskCorrectButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.width.height.equalTo(20)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.leading.equalTo(titleLabel.snp.trailing).offset(5)
        }
    }
    
    //MARK: - Button action
    
    @objc
    func taskCorrectButtonAction() {
        taskCorrectButtonDidTapped.send()
    }
}
