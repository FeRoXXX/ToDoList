//
//  TaskDetailsView.swift
//  ToDoList
//
//  Created by Александр Федоткин on 24.12.2024.
//

import UIKit
import SnapKit
import Combine

final class TaskDetailsView: UIView {
    
    //MARK: - Private properties
    
    private(set) var backButtonPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    private(set) var deleteButtonPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    private(set) var completeButtonPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString("Task Details", attributes: AttributeContainer([
            .font: UIFont(name: Fonts.poppinsMedium.rawValue, size: 16) ?? .systemFont(ofSize: 16),
            .foregroundColor: Colors.whiteColorFirst
        ]))
        configuration.image = Images.arrowLeft
        configuration.imagePadding = 14
        configuration.contentInsets = .zero
        button.configuration = configuration
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: TaskDetailsTitle = {
        let label = TaskDetailsTitle()
        return label
    }()
    
    private let dateLabel: TaskDetailsDate = {
        let label = TaskDetailsDate()
        return label
    }()
    
    private let separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = Colors.whiteColorSecond
        return separatorView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.whiteColorFirst
        label.font = UIFont(name: Fonts.poppinsMedium.rawValue, size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        configureButton(button: button, with: "Done", image: Images.complete)
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        configureButton(button: button, with: "Delete", image: Images.taskDetailsDeleteButton)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
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

private extension TaskDetailsView {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        backgroundColor = .clear
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(separatorView)
        addSubview(descriptionLabel)
        addSubview(doneButton)
        addSubview(deleteButton)
    }
    
    func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(75)
            make.leading.equalToSuperview().inset(37)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(37)
            make.top.equalTo(backButton.snp.bottom).offset(40)
            make.trailing.lessThanOrEqualToSuperview().inset(37)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(37)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.trailing.lessThanOrEqualToSuperview().inset(37)
        }
        
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(37)
            make.top.equalTo(dateLabel.snp.bottom).offset(25)
            make.height.equalTo(1)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(37)
            make.top.equalTo(separatorView.snp.bottom).offset(25)
        }
        
        doneButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(80)
            make.bottom.equalToSuperview().inset(182)
            make.top.greaterThanOrEqualTo(descriptionLabel.snp.bottom).offset(58)
            make.height.equalTo(71)
            make.width.equalTo(88)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(80)
            make.bottom.equalToSuperview().inset(182)
            make.leading.lessThanOrEqualTo(doneButton.snp.trailing).offset(72)
            make.height.equalTo(71)
            make.width.equalTo(88)
        }
        
        descriptionLabel.snp.contentHuggingVerticalPriority = .init(249)
    }
    
    //MARK: - Configure editing buttons
    
    func configureButton(button: UIButton, with text: String, image: UIImage) {
        var configuration = UIButton.Configuration.plain()
        configuration.image = image
        configuration.imagePlacement = .top
        configuration.imagePadding = 10
        configuration.background.cornerRadius = 10
        configuration.attributedTitle = AttributedString(text, attributes: AttributeContainer([
            .font: UIFont(name: Fonts.poppinsMedium.rawValue, size: 14) ?? .systemFont(ofSize: 14),
            .foregroundColor: Colors.whiteColorFirst
        ]))
        configuration.background.backgroundColor = Colors.darkBlue
        button.configuration = configuration
        button.layer.shadowColor = Colors.whiteColorFirst.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 5
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.masksToBounds = false
    }
    
    //MARK: - Buttons action
    @objc
    func backButtonTapped() {
        backButtonPublisher.send()
    }
    
    @objc
    func deleteButtonTapped() {
        deleteButtonPublisher.send()
    }
    
    @objc
    func completeButtonTapped() {
        completeButtonPublisher.send()
    }
}

//MARK: - Public extension

extension TaskDetailsView {
    
    //MARK: - Setup task data
    
    func setupTaskData(_ data: TaskDetailsModel) {
        titleLabel.titleLabel.text = data.title
        dateLabel.dateLabel.text = data.date
        dateLabel.timeLabel.text = data.time
        descriptionLabel.text = data.description
    }
}
