//
//  NewNoteViewController.swift
//  ToDoList
//
//  Created by Александр Федоткин on 23.12.2024.
//

import UIKit
import Combine

final class NewNoteViewController: UIViewController {
    
    //MARK: - Private properties
    
    private var contentView = NewNoteView()
    
    //MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
}

//MARK: - Private extension

private extension NewNoteViewController {
    
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
