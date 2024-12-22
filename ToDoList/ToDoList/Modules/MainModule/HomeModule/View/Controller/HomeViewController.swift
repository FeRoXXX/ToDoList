//
//  HomeViewController.swift
//  ToDoList
//
//  Created by Александр Федоткин on 21.12.2024.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    
    //MARK: - Private properties
    
    private var contentView = HomeView()
    
    //MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
}

//MARK: - Private extension

private extension HomeViewController {
    
    //MARK: - UI initialization function
    
    func setupUI() {
        self.view = contentView
    }
    
    //MARK: - Bind
    
    func bind() {
        
        //MARK: - bind view to viewModel
        
        func bindViewToViewModel() {
            
        }
        
        //MARK: - bind viewModel to view
        
        func bindViewModelToView() {
            
        }
        
        bindViewModelToView()
        bindViewToViewModel()
    }
}
