//
//  AlertProtocol.swift
//  ToDoList
//
//  Created by Александр Федоткин on 27.12.2024.
//

import UIKit

protocol AlertProtocol {
    func showAlert(vc: UIViewController, message: String?)
}

extension AlertProtocol {
    
    func showAlert(vc: UIViewController, message: String?) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        vc.present(alert, animated: true)
    }
}
