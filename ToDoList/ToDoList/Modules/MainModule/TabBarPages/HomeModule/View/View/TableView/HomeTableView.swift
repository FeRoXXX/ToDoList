//
//  HomeCollectionView.swift
//  ToDoList
//
//  Created by Александр Федоткин on 22.12.2024.
//

import UIKit
import Combine

final class HomeTableView: UITableView {
    
    enum Constants: String {
        case firstSectionHeader = "Incomplete Tasks"
        case secondSectionHeader = "Completed Tasks"
    }
    
    //MARK: - Private properties
    
    private(set) var cellTappedPublisher: PassthroughSubject<UUID, Never> = .init()
    
    //MARK: - Public properties
    
    var data: [[ToDoListModel]] = [] {
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

extension HomeTableView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return data[0].count
        case 1:
            return data[1].count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let view = HomeTableHeaderView()
            view.setupTitle(Constants.firstSectionHeader.rawValue)
            return view
        case 1:
            let view = HomeTableHeaderView()
            view.setupTitle(Constants.secondSectionHeader.rawValue)
            return view
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let data = data[section]
        let cell = tableView.reuse(TableViewToDoCell.self, for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.cellSpacing = 7.5
        cell.setupData(data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellTappedPublisher.send(data[indexPath.section][indexPath.row].taskId)
    }
}
