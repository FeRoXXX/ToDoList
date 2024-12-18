//
//  SignUpViewController.swift
//  ToDoList
//
//  Created by Александр Федоткин on 18.12.2024.
//

import UIKit

final class SignUpViewController: UIViewController {
    
    //MARK: - Private properties
    
    private var contentView: SignUpView = SignUpView()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

//MARK: - Private extension

private extension SignUpViewController {
    
    //MARK: - UI initialization function
    
    func setupUI() {
        self.view = contentView
    }
    
    //MARK: - Binding
    
    func bind() {
        
        //MARK: - Bind view to viewModel
        
        func bindViewToViewModel() {
            
        }
        
        //MARK: - Bind viewModel to view
        
        func bindViewModelToView() {
            
        }
        
        bindViewToViewModel()
        bindViewModelToView()
    }
}

