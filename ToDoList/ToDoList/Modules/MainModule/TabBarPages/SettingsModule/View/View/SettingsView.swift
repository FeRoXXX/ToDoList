//
//  SettingsView.swift
//  ToDoList
//
//  Created by Александр Федоткин on 22.12.2024.
//

import UIKit
import SnapKit
import Combine

final class SettingsView: UIView {
    
    enum Constants: String {
        case pageTitle = "Settings"
        case logoutButton = "Logout"
    }
    
    //MARK: - Private properties
    
    private(set) var logoutButtonPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    private var pageTitle: UILabel = {
        let label = UILabel()
        label.text = Constants.pageTitle.rawValue
        label.font = UIFont(name: Fonts.poppinsBold.rawValue, size: 18)
        label.textColor = Colors.whiteColorFirst
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.background.backgroundColor = Colors.whiteColorFirst
        configuration.baseForegroundColor = Colors.redColor
        configuration.image = Images.SettingsImages.logout
        configuration.title = Constants.logoutButton.rawValue
        configuration.imagePadding = 12
        button.configuration = configuration
        button.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
        return button
    }()
    
    private var settingsTableView: SettingsTableView = {
        let tableView = SettingsTableView(frame: .zero, style: .plain)
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
        logoutButton.layer.cornerRadius = logoutButton.frame.height / 2
        logoutButton.layer.masksToBounds = true
    }
}

//MARK: - Private extension

private extension SettingsView {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(settingsTableView)
        addSubview(logoutButton)
        addSubview(pageTitle)
    }
    
    func setupConstraints() {
        
        pageTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(75)
        }
        settingsTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(pageTitle.snp.bottom).offset(22)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(93)
            make.bottom.equalToSuperview().inset(200)
            make.top.equalTo(settingsTableView.snp.bottom).offset(95)
            make.height.equalTo(42)
        }
    }
    
    //MARK: - Button action
    
    @objc
    func logoutButtonAction() {
        logoutButtonPublisher.send()
    }
}
