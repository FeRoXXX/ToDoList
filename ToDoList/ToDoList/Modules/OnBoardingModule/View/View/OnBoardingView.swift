//
//  OnBoardingView.swift
//  ToDoList
//
//  Created by Александр Федоткин on 18.12.2024.
//

import UIKit
import SnapKit

final class OnBoardingView: UIView {
    
    //MARK: - Private properties
    
    private var pageImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private var pageTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .init(name: "Poppins-medium", size: 20)
        return label
    }()
    
    //MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout subviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.insertSublayer(Background.shared.getGradientLayer(frame: frame), at: 0)
    }
}

//MARK: - Private extension

private extension OnBoardingView {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(pageImageView)
        addSubview(pageTextLabel)
    }
    
    func setupConstraints() {
        pageImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(55)
            make.height.equalTo(300)
        }
        
        pageTextLabel.snp.makeConstraints { make in
            make.top.equalTo(pageImageView.snp.bottom).offset(65)
            make.leading.trailing.greaterThanOrEqualToSuperview().inset(67.5)
        }
    }
}
