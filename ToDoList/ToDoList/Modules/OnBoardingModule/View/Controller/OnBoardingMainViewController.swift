//
//  OnBoardingMainViewController.swift
//  ToDoList
//
//  Created by Александр Федоткин on 18.12.2024.
//

import UIKit
import Combine
import SnapKit

final class OnBoardingMainViewController: UIPageViewController {
    
    //MARK: - Private properties
    
    private let pages: [OnBoardingViewController]
    private let viewModel: OnBoardingMainViewModel
    private(set) var nextButtonTapped: PassthroughSubject<Void, Never> = .init()
    private(set) var updateCurrentIndex: PassthroughSubject<Int, Never> = .init()
    private var bindings: Set<AnyCancellable> = []
    
    private lazy var pageControl: AnimatedPageControl = {
        let pageControl = AnimatedPageControl()
        pageControl.dotHeight = 7
        pageControl.dotWidth = 18
        pageControl.selectedDotWidth = 33
        pageControl.selectedDotHeight = 7
        pageControl.numberOfPages = pages.count
        return pageControl
    }()
    
    private lazy var nextViewButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.background.backgroundColor = .white
        configuration.image = Images.systemArrowRight
        button.configuration = configuration
        button.tintColor = .black
        button.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.initializeStaticData()
//        setupScrollViewDelegate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nextViewButton.configuration?.background.cornerRadius = nextViewButton.frame.height / 2
    }
    
    //MARK: - Initialization
    
    init(viewModel: OnBoardingMainViewModel, pages: [OnBoardingViewController]) {
        self.viewModel = viewModel
        self.pages = pages
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.dataSource = self
        self.delegate = self
        setViewControllers([pages[0]], direction: .forward, animated: false)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension

private extension OnBoardingMainViewController {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        view.addSubview(pageControl)
        view.addSubview(nextViewButton)
    }
    
    func setupConstraints() {
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(pageControl.frame.height)
            make.width.equalTo(pageControl.frame.width)
            make.bottom.equalToSuperview().inset(88)
        }
        
        nextViewButton.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.leading.equalTo(pageControl.snp.trailing).offset(56)
            make.centerY.equalTo(pageControl.snp.centerY)
        }
    }
    
    //MARK: - Bindings
    
    func bind() {
        
        //MARK: - Bind view to viewModel
        
        func bindViewToViewModel() {
            nextButtonTapped
                .receive(on: DispatchQueue.global())
                .sink { [weak self] _ in
                    self?.viewModel.calculatePage()
                }
                .store(in: &bindings)
            updateCurrentIndex
                .receive(on: DispatchQueue.global())
                .sink { [weak self] index in
                    self?.viewModel.updatePage(index: index)
                }
                .store(in: &bindings)
        }
        
        //MARK: - Bind viewModel to view
        
        func bindViewModelToView() {
            viewModel.currentPagePublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let pages = self?.pages else { return }
                    self?.setViewControllers([pages[value]], direction: .forward, animated: true, completion: nil)
                    self?.setupCurrentPage(value)
                }
                .store(in: &bindings)
            
            viewModel.staticDataPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let pages = self?.pages as? [OnBoardingViewController] else { return }
                    pages.enumerated().forEach { index, page in
                        page.setupStaticContent(value[index])
                    }
                }
                .store(in: &bindings)
            
            viewModel.changeImage
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.setupNextButtonImage(value)
                }
                .store(in: &bindings)
        }
        
        bindViewModelToView()
        bindViewToViewModel()
    }
    
    //MARK: - Button action
    
    @objc
    func nextButtonClicked() {
        nextButtonTapped.send()
    }
    
    //MARK: - Setup current page
    
    func setupCurrentPage(_ page: Int) {
        pageControl.currentPage = page
    }
    
    //MARK: - Setup next button image
    
    func setupNextButtonImage(_ imageName: String) {
        if let image = UIImage(named: imageName) {
            nextViewButton.configuration?.image = image
        } else {
            nextViewButton.configuration?.image = UIImage(systemName: imageName)
        }
    }

}

//MARK: - UIPageControllerDelegate, UIPageControllerDataSource

extension OnBoardingMainViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? OnBoardingViewController,
              let index = pages.firstIndex(of: viewController),
                index > 0 else { return nil }
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? OnBoardingViewController,
                let index = pages.firstIndex(of: viewController),
                index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?.first as? OnBoardingViewController,
              let index = pages.firstIndex(of: viewController) else { return }
        setupCurrentPage(index)
        updateCurrentIndex.send(index)
    }
}


