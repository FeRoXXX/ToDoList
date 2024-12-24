//
//  TaskDetailsViewController.swift
//  ToDoList
//
//  Created by Александр Федоткин on 24.12.2024.
//

import UIKit
import Combine

final class TaskDetailsViewController: UIViewController {
    
    //MARK: - Private properties
    
    private var contentView = TaskDetailsView()
    private var viewModel: TaskDetailsViewModel
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.loadData()
    }
    
    //MARK: - Initialization
    
    init(viewModel: TaskDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension

private extension TaskDetailsViewController {
    
    //MARK: - UI initialization function
    
    func setupUI() {
        self.view = contentView
    }
    
    //MARK: - Bind
    
    func bind() {
        
        //MARK: - bind view to viewModel
        
        func bindViewToViewModel() {
            contentView.backButtonPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.viewModel.navigateToBack()
                }
                .store(in: &bindings)
            
            contentView.deleteButtonPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.viewModel.deleteTaskById()
                }
                .store(in: &bindings)
            
            contentView.completeButtonPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.viewModel.updateTaskById()
                }
                .store(in: &bindings)
        }
        
        //MARK: - bind viewModel to view
        
        func bindViewModelToView() {
            viewModel.pushTaskDetails
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.contentView.setupTaskData(value)
                }
                .store(in: &bindings)
        }
        
        bindViewModelToView()
        bindViewToViewModel()
    }
}

