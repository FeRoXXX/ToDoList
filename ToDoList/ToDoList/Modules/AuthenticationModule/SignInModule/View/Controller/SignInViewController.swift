//
//  SignInViewController.swift
//  ToDoList
//
//  Created by Александр Федоткин on 16.12.2024.
//

import UIKit
import Combine

final class SignInViewController: UIViewController {
    
    //MARK: - Private properties
    
    private var contentView: SignInView = SignInView()
    private var viewModel: SignInViewModel
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadConstants()
    }
    
    //MARK: - Initialization
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension

private extension SignInViewController {
    
    //MARK: - UI initialization function
    
    func setupUI() {
        self.view = contentView
    }
    
    //MARK: - Binding
    
    func bind() {
        
        //MARK: - Bind view to viewModel
        
        func bindViewToViewModel() {
            contentView.textDidTapped
                .receive(on: DispatchQueue.global())
                .sink { [weak self] _ in
                    self?.viewModel.goToSignUpView()
                }
                .store(in: &bindings)
            
            contentView.signInDidTapped
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.viewModel.signIn(email: value.email,
                                           password: value.password)
                }
                .store(in: &bindings)
        }
        
        //MARK: - Bind viewModel to view
        
        func bindViewModelToView() {
            viewModel.pushStaticTextPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.contentView.setupStaticText(value)
                }
                .store(in: &bindings)
            
            viewModel.showErrorPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.makeError(error: value)
                }
                .store(in: &bindings)
        }
        
        bindViewToViewModel()
        bindViewModelToView()
    }
    
    //MARK: - Make error alert
    
    func makeError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}
