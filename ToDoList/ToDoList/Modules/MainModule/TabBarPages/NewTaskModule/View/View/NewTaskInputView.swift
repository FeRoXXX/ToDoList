//
//  NewTaskInputView.swift
//  ToDoList
//
//  Created by Александр Федоткин on 23.12.2024.
//

import UIKit
import SnapKit
import Combine

final class NewTaskInputView: UIView {
    
    enum Constants: String {
        case taskTextFieldPlaceholder = "task"
        case descriptionTextFieldPlaceholder = "Description"
        case dateTextFieldPlaceholder = "Date"
        case timeTextFieldPlaceholder = "Time"
        case cancelButtonTitle = "Cancel"
        case createButtonTitle = "Create"
    }
    
    //MARK: - Private properties
    
    private(set) var createNewTaskPublisher: PassthroughSubject<NewTaskDataModel, Never> = .init()
    private(set) var cancelPublisher: PassthroughSubject<Void, Never> = .init()
        
    //MARK: - Public properties
    
    var taskTitleField: CustomTextField = {
        let textField = CustomTextField()
        textField.addImage(Images.TextFieldImages.taskTitle, imageDirection: .left)
        textField.attributesForPlaceholder = [.font: UIFont(name: Fonts.poppinsRegular.rawValue, size: 16) ?? .systemFont(ofSize: 16), .foregroundColor: Colors.whiteColorSecond]
        textField.addAttributedPlaceholder(Constants.taskTextFieldPlaceholder.rawValue)
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
        textView.leftImage = Images.TextFieldImages.taskDescription
        textView.attributedText = NSAttributedString(string: Constants.descriptionTextFieldPlaceholder.rawValue, attributes: [
            .font: UIFont(name: Fonts.poppinsRegular.rawValue, size: 16) ?? .systemFont(ofSize: 16),
            .foregroundColor: Colors.whiteColorSecond
        ])
        textView.delegate = textView
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
    
    lazy var dateTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.addImage(Images.TextFieldImages.taskDate, imageDirection: .left)
        textField.attributesForPlaceholder = [.font: UIFont(name: Fonts.poppinsRegular.rawValue, size: 16) ?? .systemFont(ofSize: 16), .foregroundColor: Colors.whiteColorSecond]
        textField.addAttributedPlaceholder(Constants.dateTextFieldPlaceholder.rawValue)
        textField.backgroundColor = Colors.darkBlue
        textField.textColor = Colors.whiteColorFirst
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.setInputViewDatePicker(target: self, selector: #selector(dateTextFieldDoneTapped), type: .date)
        return textField
    }()
    
    lazy var timeTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.addImage(Images.TextFieldImages.taskTime, imageDirection: .left)
        textField.attributesForPlaceholder = [.font: UIFont(name: Fonts.poppinsRegular.rawValue, size: 16) ?? .systemFont(ofSize: 16), .foregroundColor: Colors.whiteColorSecond]
        textField.addAttributedPlaceholder(Constants.timeTextFieldPlaceholder.rawValue)
        textField.backgroundColor = Colors.darkBlue
        textField.textColor = Colors.whiteColorFirst
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.setInputViewDatePicker(target: self, selector: #selector(timeTextFieldDoneTapped), type: .time)
        return textField
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.background.backgroundColor = Colors.whiteColorFirst
        configuration.attributedTitle = AttributedString(Constants.cancelButtonTitle.rawValue, attributes: AttributeContainer([
            .font: UIFont(name: Fonts.poppinsMedium.rawValue, size: 16) ?? .systemFont(ofSize: 16),
            .foregroundColor: Colors.blackColorFirst
        ]))
        button.configuration = configuration
        button.layer.borderColor = Colors.lightBlueThird.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(cancelCreateNewTask), for: .touchUpInside)
        return button
    }()
    
    lazy var createButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.background.cornerRadius = 10
        configuration.background.backgroundColor = Colors.lightBlueThird
        configuration.attributedTitle = AttributedString(Constants.createButtonTitle.rawValue, attributes: AttributeContainer([
            .font: UIFont(name: Fonts.poppinsMedium.rawValue, size: 16) ?? .systemFont(ofSize: 16),
            .foregroundColor: Colors.whiteColorFirst
        ]))
        button.configuration = configuration
        button.addTarget(self, action: #selector(createNewTaskButtonTapped), for: .touchUpInside)
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

private extension NewTaskInputView {
    
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
    
    //MARK: - Keyboard actions
    
    @objc func dateTextFieldDoneTapped() {
        if let datePicker = self.dateTextField.inputView as? UIDatePicker,
           datePicker.datePickerMode == .date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "dd/MM/yyyy"
            self.dateTextField.attributedText = NSAttributedString(string: dateFormatter.string(from: datePicker.date), attributes: [.font: UIFont(name: Fonts.poppinsRegular.rawValue, size: 16) ?? .systemFont(ofSize: 16), .foregroundColor: Colors.whiteColorSecond])
        }
        self.resignFirstResponder()
    }
    
    @objc func timeTextFieldDoneTapped() {
        if let datePicker = self.timeTextField.inputView as? UIDatePicker,
           datePicker.datePickerMode == .time {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .medium
            dateFormatter.dateFormat = "HH:mm"
            self.timeTextField.attributedText = NSAttributedString(string: dateFormatter.string(from: datePicker.date), attributes: [.font: UIFont(name: Fonts.poppinsRegular.rawValue, size: 16) ?? .systemFont(ofSize: 16), .foregroundColor: Colors.whiteColorSecond])
        }
        self.resignFirstResponder()
    }
    
    //MARK: - Button actions
    
    @objc
    func createNewTaskButtonTapped() {
        createNewTaskPublisher.send(NewTaskDataModel(title: taskTitleField.text,
                                                     description: descriptionTextView.text,
                                                     date: dateTextField.text,
                                                     time: timeTextField.text))
    }
    
    @objc
    func cancelCreateNewTask() {
        cancelPublisher.send()
    }
}
