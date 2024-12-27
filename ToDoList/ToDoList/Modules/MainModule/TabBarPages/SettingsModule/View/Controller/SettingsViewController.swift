//
//  SettingsViewController.swift
//  ToDoList
//
//  Created by Александр Федоткин on 22.12.2024.
//

import UIKit
import Combine

final class SettingsViewController: UIViewController, AlertProtocol {
    
    //MARK: - Private properties
    
    private var contentView = SettingsView()
    private var cancelButtonDidTapped: PassthroughSubject<Void, Never> = .init()
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
    
    //MARK: - Show alert
    
    func showAlert(vc: UIViewController, message: String?) {
        let alertExit = UIAlertAction(title: "Exit", style: .destructive) { [weak self] _ in
            self?.cancelButtonDidTapped.send()
        }
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel)
        let alertController = UIAlertController(title: "Are you sure?", message: "press exit to confirm", preferredStyle: .alert)
        alertController.addAction(alertCancel)
        alertController.addAction(alertExit)
        vc.present(alertController, animated: true)
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
                    guard let self else { return }
                    showAlert(vc: self, message: nil)
                }
                .store(in: &bindings)
            cancelButtonDidTapped
                .receive(on: DispatchQueue.global())
                .sink { [weak self] _ in
                    self?.viewModel.logout()
                }
                .store(in: &bindings)
        }
        
        bindViewToViewModel()
    }
}
