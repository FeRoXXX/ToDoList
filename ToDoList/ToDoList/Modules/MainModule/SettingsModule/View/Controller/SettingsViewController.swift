//
//  SettingsViewController.swift
//  ToDoList
//
//  Created by Александр Федоткин on 22.12.2024.
//

import UIKit
import Combine

final class SettingsViewController: UIViewController {
    
    //MARK: - Private properties
    
    private var contentView = SettingsView()
    private var viewModel: SettingsViewModel
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.loadData()
    }
    
    //MARK: - Initialization
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension

private extension SettingsViewController {
    
    //MARK: - UI initialization function
    
    func setupUI() {
        self.view = contentView
    }
    
    //MARK: - Bind
    
    func bind() {
        
        //MARK: - bind view to viewModel
        
        func bindViewToViewModel() {
            contentView.logoutButtonPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.viewModel.logout()
                }
                .store(in: &bindings)
        }
        
        //MARK: - bind viewModel to view
        
        func bindViewModelToView() {
        }
        
        bindViewModelToView()
        bindViewToViewModel()
    }
}
