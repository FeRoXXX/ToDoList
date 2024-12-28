//
//  HomeView.swift
//  ToDoList
//
//  Created by Александр Федоткин on 21.12.2024.
//

import UIKit
import SnapKit
import Combine

final class HomeView: UIView {
    
    //MARK: - Private properties
    
    private var fullNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.whiteColorFirst
        label.font = UIFont(name: Fonts.poppinsBold.rawValue, size: 18)
        return label
    }()
    
    private var emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.whiteColorFourth
        label.font = UIFont(name: Fonts.poppinsMedium.rawValue, size: 14)
        return label
    }()
    
    //MARK: - Public properties
    
    var tableView: HomeTableView = {
        let tableView = HomeTableView(frame: .zero, style: .grouped)
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

private extension HomeView {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        backgroundColor = Colors.clearColor
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(emailLabel)
        addSubview(fullNameLabel)
        addSubview(tableView)
    }
    
    func setupConstraints() {
        fullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).inset(70)
            make.leading.trailing.equalToSuperview().inset(21)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(21)
            make.top.equalTo(fullNameLabel.snp.bottom)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(71)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

//MARK: - Public extension

extension HomeView {
    
    //MARK: - Setup profile data
    
    func setupProfileData(_ data: UserPublicDataModel) {
        emailLabel.text = data.email
        fullNameLabel.text = data.fullName
    }
}
