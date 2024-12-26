//
//  Extension+UICollectionViewCell.swift
//  ToDoList
//
//  Created by Александр Федоткин on 22.12.2024.
//

import UIKit

extension UITableViewCell {
    
    //MARK: - Cell identifier
    
    static var identifier: String {
        String(describing: self)
    }
}
