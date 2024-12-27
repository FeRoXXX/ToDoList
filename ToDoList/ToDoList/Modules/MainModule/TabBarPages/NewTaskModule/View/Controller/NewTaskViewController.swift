//
//  NewTaskViewController.swift
//  ToDoList
//
//  Created by Александр Федоткин on 23.12.2024.
//

import UIKit
import Combine

final class NewTaskViewController: UIViewController, AlertProtocol {
    
    //MARK: - Private properties
    
    private var viewModel: NewTaskViewModel
    private var contentView = NewTaskView()
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.viewLoaded()
    }
    
    //MARK: - Initialization
    
    init(viewModel: NewTaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension

private extension NewTaskViewController {
    
    //MARK: - UI initialization function
    
    func setupUI() {
        self.view = contentView
    }
    
    //MARK: - Bind
    
    func bind() {
        
        //MARK: - bind view to viewModel
        
        func bindViewToViewModel() {
            contentView.contentView.createNewTaskPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.viewModel.pushTaskData(value)
                }
                .store(in: &bindings)
            
            contentView.contentView.cancelPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.viewModel.cancelTaskCreation()
                }
                .store(in: &bindings)
        }
        
        //MARK: - bind viewModel to view
        
        func bindViewModelToView() {
            viewModel.$pushTaskDetails
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let value else { return }
                    self?.contentView.setupTaskData(value)
                }
                .store(in: &bindings)
            
            viewModel.$pushTaskDetailsError
                .receive(on: DispatchQueue.main)
                .sink { [weak self] error in
                    guard let error,
                    let self else { return }
                    self.showAlert(vc: self, message: error)
                }
                .store(in: &bindings)
        }
        
        bindViewModelToView()
        bindViewToViewModel()
    }
}
