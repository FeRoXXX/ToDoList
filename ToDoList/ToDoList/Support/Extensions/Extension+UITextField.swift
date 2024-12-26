//
//  Extension+UITextField.swift
//  ToDoList
//
//  Created by Александр Федоткин on 24.12.2024.
//

import UIKit

extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector, type: UIDatePicker.Mode) {
        
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = type
        datePicker.preferredDatePickerStyle = .wheels
        self.inputView = datePicker
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: true)
        self.inputAccessoryView = toolBar
    }
}

