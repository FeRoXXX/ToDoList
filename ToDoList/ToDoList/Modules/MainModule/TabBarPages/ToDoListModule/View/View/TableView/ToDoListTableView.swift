//
//  ToDoListTableView.swift
//  ToDoList
//
//  Created by Александр Федоткин on 22.12.2024.
//

import UIKit
import Combine

final class ToDoListTableView: UITableView {
    
    enum Constants: String {
        case headerText = "Tasks List"
    }
    
    //MARK: - Private properties
    
    private(set) var selectedRowPublisher: PassthroughSubject<UUID, Never> = .init()
    
    //MARK: - Public properties
    
    var data: [ToDoListModel] = [] {
        didSet {
            updateIndexPaths(oldValue: oldValue, data: data)
        }
    }
    
    //MARK: - Initialization
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        register(TableViewToDoCell.self)
        self.delegate = self
        self.dataSource = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ToDoListTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = ToDoListHeaderView()
        view.setupTitle(Constants.headerText.rawValue)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = data[indexPath.row]
        let cell = tableView.reuse(TableViewToDoCell.self, for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.cellSpacing = 17.5
        cell.setupData(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRowPublisher.send(data[indexPath.row].taskId)
    }
}
