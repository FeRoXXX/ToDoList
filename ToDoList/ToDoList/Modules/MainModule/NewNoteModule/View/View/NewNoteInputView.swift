//
//  NewNoteInputView.swift
//  ToDoList
//
//  Created by Александр Федоткин on 23.12.2024.
//

import UIKit
import SnapKit
import Combine

final class NewNoteInputView: UIView {
    
    //MARK: - Private properties
    
    var taskTitleField: CustomTextField = {
        let textField = CustomTextField()
        textField.addImage(Images.taskTitle, imageDirection: .left)
        textField.attributesForPlaceholder = [.font: UIFont(name: Fonts.poppinsRegular.rawValue, size: 16) ?? .systemFont(ofSize: 16), .foregroundColor: Colors.whiteColorSecond]
        textField.addAttributedPlaceholder("task")
        textField.backgroundColor = Colors.darkBlue
        textField.textColor = Colors.whiteColorFirst
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        return textField
    }()
    
    var descriptionTextView: CustomTextView = {
        let textView = CustomTextView()
        textView.backgroundColor = Colors.darkBlue
        textView.textColor = Colors.whiteColorFirst
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = true
        textView.leftImage = Images.taskDescription
        textView.attributedText = NSAttributedString(string: "Description", attributes: [
            .font: UIFont(name: Fonts.poppinsRegular.rawValue, size: 16) ?? .systemFont(ofSize: 16),
            .foregroundColor: Colors.whiteColorSecond
        ])
        return textView
    }()
    
    lazy var horizontalStackViewForTextFields: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateTextField, timeTextField])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 19
        return stackView
    }()
    
    lazy var horizontalStackViewForButtons: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 19
        return stackView
    }()
    
    var dateTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.addImage(Images.taskDate, imageDirection: .left)
        textField.attributesForPlaceholder = [.font: UIFont(name: Fonts.poppinsRegular.rawValue, size: 16) ?? .systemFont(ofSize: 16), .foregroundColor: Colors.whiteColorSecond]
        textField.addAttributedPlaceholder("Date")
        textField.backgroundColor = Colors.darkBlue
        textField.textColor = Colors.whiteColorFirst
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        return textField
    }()
    
    var timeTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.addImage(Images.taskTime, imageDirection: .left)
        textField.attributesForPlaceholder = [.font: UIFont(name: Fonts.poppinsRegular.rawValue, size: 16) ?? .systemFont(ofSize: 16), .foregroundColor: Colors.whiteColorSecond]
        textField.addAttributedPlaceholder("Time")
        textField.backgroundColor = Colors.darkBlue
        textField.textColor = Colors.whiteColorFirst
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        return textField
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.background.backgroundColor = Colors.whiteColorFirst
        configuration.attributedTitle = AttributedString("cancel", attributes: AttributeContainer([
            .font: UIFont(name: Fonts.poppinsMedium.rawValue, size: 16) ?? .systemFont(ofSize: 16),
            .foregroundColor: Colors.blackColorFirst
        ]))
        button.configuration = configuration
        button.layer.borderColor = Colors.lightBlueThird.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    
    var createButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.background.cornerRadius = 10
        configuration.background.backgroundColor = Colors.lightBlueThird
        configuration.attributedTitle = AttributedString("create", attributes: AttributeContainer([
            .font: UIFont(name: Fonts.poppinsMedium.rawValue, size: 16) ?? .systemFont(ofSize: 16),
            .foregroundColor: Colors.whiteColorFirst
        ]))
        button.configuration = configuration
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
    
}

//MARK: - Private extension

private extension NewNoteInputView {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(taskTitleField)
        addSubview(descriptionTextView)
        addSubview(horizontalStackViewForTextFields)
        addSubview(horizontalStackViewForButtons)
    }
    
    func setupConstraints() {
        taskTitleField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(27)
            make.height.equalTo(42)
            make.top.equalToSuperview().inset(54)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(27)
            make.top.equalTo(taskTitleField.snp.bottom).offset(34)
            make.height.equalTo(159)
        }
        
        horizontalStackViewForTextFields.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(27)
            make.height.equalTo(42)
            make.top.equalTo(descriptionTextView.snp.bottom).offset(22)
        }
        
        horizontalStackViewForButtons.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(27)
            make.height.equalTo(42)
            make.bottom.equalToSuperview().inset(25)
            make.top.equalTo(horizontalStackViewForTextFields.snp.bottom).offset(20)
        }
    }
}
