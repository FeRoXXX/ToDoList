//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Александр Федоткин on 22.12.2024.
//

import UIKit
import Combine

final class ToDoListViewController: UIViewController {
    
    //MARK: - Private properties
    
    private var contentView = ToDoListView()
    private var viewModel: ToDoListViewModel
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.loadData()
    }
    
    //MARK: - Initialization
    
    init(viewModel: ToDoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension

private extension ToDoListViewController {
    
    //MARK: - UI initialization function
    
    func setupUI() {
        self.view = contentView
    }
    
    //MARK: - Bind
    
    func bind() {
        
        //MARK: - bind view to viewModel
        
        func bindViewToViewModel() {
            contentView.addButtonDidTappedPublisher
                .receive(on: DispatchQueue.global())
                .sink { [weak self] _ in
                    self?.viewModel.navigateToAddNewTask()
                }
                .store(in: &bindings)
            
            contentView.tableView.selectedRowPublisher
                .receive(on: DispatchQueue.global())
                .sink { [weak self] taskId in
                    self?.viewModel.navigateToTaskDetails(taskId: taskId)
                }
                .store(in: &bindings)
        }
        
        //MARK: - bind viewModel to view
        
        func bindViewModelToView() {
            
            viewModel.$tasksData
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.contentView.tableView.data = value
                }
                .store(in: &bindings)
        }
        
        bindViewModelToView()
        bindViewToViewModel()
    }
}
