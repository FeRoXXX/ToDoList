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
    private var viewWillAppearPublisher: PassthroughSubject<Date, Never> = .init()
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.viewLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let selectedDate = contentView.tasksCalendar.selectedDate else { return }
        viewWillAppearPublisher.send(selectedDate)
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
            
            viewWillAppearPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] currentDate in
                    self?.viewModel.requestTasks(currentDate)
                }
                .store(in: &bindings)
        }
        
        //MARK: - bind viewModel to view
        
        func bindViewModelToView() {
            viewModel.$tableViewData
                .receive(on: DispatchQueue.main)
                .sink { [weak self] data in
                    self?.contentView.tableView.data = data
                }
                .store(in: &bindings)
            viewModel.$datesOfEvents
                .receive(on: DispatchQueue.main)
                .sink { [weak self] dates in
                    self?.contentView.tasksCalendar.numberOfEvents = dates
                }
                .store(in: &bindings)
        }
        
        bindViewModelToView()
        bindViewToViewModel()
    }
}

