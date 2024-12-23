//
//  Extension+UICollectionView.swift
//  ToDoList
//
//  Created by Александр Федоткин on 22.12.2024.
//

import UIKit

extension UITableView {
    
    //MARK: - Cell registration
    
    func register<T:UITableViewCell>(_ type:T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    //MARK: - Cell reuse
       
    func reuse<T:UITableViewCell>(_ type:T.Type, for indexPath:IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else { fatalError() }
        return cell
    }
    
    //MARK: - Calculate index paths
    
    private func calculateIndexPaths<T: Equatable>(oldValue: [[T]], value: [[T]]) -> (inserted: [IndexPath], deleted: [IndexPath], updated: [IndexPath]) {
        var inserted: [IndexPath] = []
        var deleted: [IndexPath] = []
        var updated: [IndexPath] = []
        
        let oldDataMap = oldValue.enumerated().flatMap { sectionIndex, rows in
            rows.enumerated().map { rowIndex, model in
                (IndexPath(row: rowIndex, section: sectionIndex), model)
            }
        }
        let newDataMap = value.enumerated().flatMap { sectionIndex, rows in
            rows.enumerated().map { rowIndex, model in
                (IndexPath(row: rowIndex, section: sectionIndex), model)
            }
        }
        
        let oldIndexPaths = Set(oldDataMap.map { $0.0 })
        let newIndexPaths = Set(newDataMap.map { $0.0 })
        
        deleted = Array(oldIndexPaths.subtracting(newIndexPaths))
        
        inserted = Array(newIndexPaths.subtracting(oldIndexPaths))
        
        let oldModelMap = Dictionary(uniqueKeysWithValues: oldDataMap)
        let newModelMap = Dictionary(uniqueKeysWithValues: newDataMap)
        
        for (indexPath, oldModel) in oldModelMap {
            guard let newModel = newModelMap[indexPath] else {
                continue
            }
            if oldModel != newModel {
                updated.append(indexPath)
            }
        }
        
        return (inserted: inserted, deleted: deleted, updated: updated)
    }
    
    //MARK: - Update table view
    
    func updateIndexPaths<T:Equatable>(oldValue: [[T]], data: [[T]]) {
        let indexPaths = calculateIndexPaths(oldValue: oldValue, value: data)
        let nonEmptySectionsCount = data.filter { !$0.isEmpty }.count
        
        self.beginUpdates()
        if nonEmptySectionsCount > 1 {
            self.reloadData()
        } else {
            if !indexPaths.inserted.isEmpty {
                self.insertRows(at: indexPaths.inserted, with: .automatic)
            }
            
            if !indexPaths.deleted.isEmpty {
                self.deleteRows(at: indexPaths.deleted, with: .automatic)
            }
            
            if !indexPaths.updated.isEmpty {
                self.reloadRows(at: indexPaths.updated, with: .automatic)
            }
        }
        self.endUpdates()
    }
}
