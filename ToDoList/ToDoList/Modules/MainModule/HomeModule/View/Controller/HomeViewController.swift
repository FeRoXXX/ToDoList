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
    private var viewModel: HomeViewModel
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.loadData()
    }
    
    //MARK: - Initialization
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            viewModel.pushTableViewData
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.contentView.tableView.data = value
                }
                .store(in: &bindings)
            
            viewModel.pushUserProfileData
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.contentView.setupProfileData(value)
                }
                .store(in: &bindings)
        }
        
        bindViewModelToView()
        bindViewToViewModel()
    }
}
