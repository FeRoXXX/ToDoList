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
}
