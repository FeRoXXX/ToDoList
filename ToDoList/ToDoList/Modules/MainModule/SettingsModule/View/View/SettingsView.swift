//
//  SettingsView.swift
//  ToDoList
//
//  Created by Александр Федоткин on 22.12.2024.
//

import UIKit
import SnapKit

final class SettingsView: UIView {
    
    //MARK: - Private properties
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.background.backgroundColor = Colors.whiteColorFirst
        configuration.baseForegroundColor = Colors.redColor
        configuration.image = Images.logout
        configuration.title = "Logout"
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

private extension SettingsView {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        
    }
    
    func setupConstraints() {
        
    }
}
