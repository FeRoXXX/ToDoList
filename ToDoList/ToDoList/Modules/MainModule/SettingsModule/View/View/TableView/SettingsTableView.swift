//
//  SettingsTableView.swift
//  ToDoList
//
//  Created by Александр Федоткин on 22.12.2024.
//

import UIKit

final class SettingsTableView: UITableView {
    
    //MARK: - Private properties
    
    private var data: [SettingsTableViewModel] = [
        .init(image: Images.profile, title: "Profile"),
        .init(image: Images.conversations, title: "Conversations"),
        .init(image: Images.project, title: "Projects"),
        .init(image: Images.policies, title: "Terms and Policies")
    ]
    
    //MARK: - Initialization
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        register(SettingsTableViewCell.self)
        self.delegate = self
        self.dataSource = self
        separatorStyle = .none
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SettingsTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = data[indexPath.row]
        let cell = tableView.reuse(SettingsTableViewCell.self, for: indexPath)
        cell.backgroundColor = Colors.clearColor
        cell.selectionStyle = .none
        cell.setupData(data)
        return cell
    }
}
