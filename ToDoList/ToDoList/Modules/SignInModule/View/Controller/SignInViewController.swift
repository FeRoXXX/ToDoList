//
//  SignInViewController.swift
//  ToDoList
//
//  Created by Александр Федоткин on 16.12.2024.
//

import UIKit

final class SignInViewController: UIViewController {
    
    //MARK: - Private properties
    
    private var contentView: SignInView = SignInView()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

//MARK: - Private extension

private extension SignInViewController {
    
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
