//
//  CalendarViewController.swift
//  ToDoList
//
//  Created by Александр Федоткин on 25.12.2024.
//

import UIKit
import Combine

final class CalendarViewController: UIViewController {
    
    //MARK: - Private properties
    
    private var viewModel: CalendarViewModel
    private var contentView = CalendarView()
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.viewLoaded()
    }
    
    //MARK: - Initialization
    
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension

private extension CalendarViewController {
    
    //MARK: - UI initialization function
    
    func setupUI() {
        self.view = contentView
    }
    
    //MARK: - Bind
    
    func bind() {
        
        //MARK: - bind view to viewModel
        
        func bindViewToViewModel() {
            contentView.tableView.selectedRowPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] id in
                    self?.viewModel.navigateToDetailById(id)
                }
                .store(in: &bindings)
            
            contentView.tasksCalendar.selectedDatePublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] date in
                    self?.viewModel.requestTasks(date)
                }
                .store(in: &bindings)
        }
        
        //MARK: - bind viewModel to view
        
        func bindViewModelToView() {
            viewModel.pushTableData
                .receive(on: DispatchQueue.main)
                .sink { [weak self] data in
                    self?.contentView.tableView.data = data
                }
                .store(in: &bindings)
        }
        
        bindViewModelToView()
        bindViewToViewModel()
    }
}

