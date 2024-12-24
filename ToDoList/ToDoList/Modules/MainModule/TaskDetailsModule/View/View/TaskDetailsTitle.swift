//
//  TaskDetailsTitle.swift
//  ToDoList
//
//  Created by Александр Федоткин on 24.12.2024.
//

import UIKit
import SnapKit
import Combine

final class TaskDetailsTitle: UIView {
    
    //MARK: - Public properties
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.poppinsMedium.rawValue, size: 18)
        label.textColor = Colors.whiteColorFirst
        label.numberOfLines = 2
        return label
    }()
    
    let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.taskDetailsTitle
        imageView.contentMode = .scaleAspectFit
        return imageView
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
    }
}

//MARK: - Private extension

private extension TaskDetailsTitle {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        backgroundColor = .clear
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(titleLabel)
        addSubview(titleImageView)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        titleImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.width.height.equalTo(20)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.leading.equalTo(titleLabel.snp.trailing).offset(5)
        }
    }
}
