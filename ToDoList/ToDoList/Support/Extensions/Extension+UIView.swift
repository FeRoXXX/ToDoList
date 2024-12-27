//
//  Extension+UIView.swift
//  ToDoList
//
//  Created by Александр Федоткин on 27.12.2024.
//

import UIKit

extension UIView {
    
    //MARK: - Add tap gesture
    
    func addHidingKeyboardGesture() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTappedAction))
        addGestureRecognizer(gestureRecognizer)
    }
    
    @objc
    func viewTappedAction() {
        endEditing(true)
    }
}
