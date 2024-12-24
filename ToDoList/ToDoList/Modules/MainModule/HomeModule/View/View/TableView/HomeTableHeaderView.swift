//
//  HomeTableHeaderView.swift
//  ToDoList
//
//  Created by Александр Федоткин on 22.12.2024.
//

import UIKit
import SnapKit

final class HomeTableHeaderView: UIView {
    
    //MARK: - Private properties
    
    private var title: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.poppinsMedium.rawValue, size: 14)
        label.textColor = Colors.whiteColorFirst
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
}

//MARK: - Private extension

private extension HomeTableHeaderView {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        backgroundColor = Colors.clearColor
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(title)
    }
    
    func setupConstraints() {
        title.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(21)
            make.bottom.equalToSuperview().inset(10)
            make.top.equalToSuperview()
        }
    }
}

//MARK: - Public extension

extension HomeTableHeaderView {
    
    //MARK: - Setup title function
    
    func setupTitle(_ text: String) {
        title.text = text
    }
}
