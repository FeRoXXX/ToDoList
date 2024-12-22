//
//  SettingsTableViewCell.swift
//  ToDoList
//
//  Created by Александр Федоткин on 22.12.2024.
//

import UIKit
import SnapKit

final class SettingsTableViewCell: UITableViewCell {
    
    //MARK: - Private properties
    
    
    
    //MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension

private extension SettingsTableViewCell {
    
    //MARK: - UI initialization function
    
    func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
       
    }
    
    func setupConstraints() {
        
    }
}

//MARK: - Public extension

extension SettingsTableViewCell {
    
    //MARK: - Setup data
    
    func setupData(_ data: ToDoListModel) {
        
    }
}
