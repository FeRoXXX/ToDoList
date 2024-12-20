//
//  OnBoardingViewController.swift
//  ToDoList
//
//  Created by Александр Федоткин on 19.12.2024.
//

import UIKit

final class OnBoardingViewController: UIViewController {
    
    //MARK: - Private properties
    
    private let contentView = OnBoardingView()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStaticContent(_ data: OnBoardingStaticElements) {
        contentView.setupStaticElement(data)
    }
}

//MARK: - Private extension

private extension OnBoardingViewController {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        self.view = contentView
    }
}
