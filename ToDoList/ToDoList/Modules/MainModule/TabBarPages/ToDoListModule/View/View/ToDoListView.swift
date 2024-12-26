//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Александр Федоткин on 22.12.2024.
//

import UIKit
import SnapKit
import Combine

final class ToDoListView: UIView {
    
    //MARK: - Private properties
    
    private(set) var addButtonDidTappedPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    private var searchField: CustomTextField = {
        let searchField = CustomTextField()
        searchField.backgroundColor = Colors.darkBlueSecond
        searchField.addImage(Images.TextFieldImages.search, imageDirection: .right)
        searchField.imageColor = Colors.whiteColorFourth
        searchField.attributesForPlaceholder = [.font: UIFont(name: Fonts.poppinsMedium.rawValue, size: 12) ?? .systemFont(ofSize: 12), .foregroundColor: Colors.whiteColorFourth]
        searchField.addAttributedPlaceholder("Search by task title")
        searchField.layer.cornerRadius = 10
        searchField.layer.masksToBounds = true
        searchField.leftViewMode = .always
        searchField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        return searchField
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = Images.TaskImages.plus
        configuration.background.backgroundColor = Colors.lightBlueSecond
        button.configuration = configuration
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Public properties
    
    var tableView: ToDoListTableView = {
        let tableView = ToDoListTableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
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
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.layer.masksToBounds = true
    }
}

//MARK: - Private extension

private extension ToDoListView {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        backgroundColor = .clear
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(searchField)
        addSubview(tableView)
        addSubview(addButton)
    }
    
    func setupConstraints() {
        searchField.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).inset(89)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(42)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchField.snp.bottom).offset(46)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.width.equalTo(addButton.snp.height)
            make.height.equalTo(50)
            make.trailing.equalToSuperview().inset(29)
            make.bottom.equalToSuperview().inset(20)
        }
        
    }
    
    //MARK: - Button actions
    
    @objc func addButtonTapped() {
        addButtonDidTappedPublisher.send()
    }
}
