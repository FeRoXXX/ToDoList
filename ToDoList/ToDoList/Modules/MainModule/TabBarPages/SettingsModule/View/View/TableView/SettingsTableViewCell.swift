//
//  SettingsTableViewCell.swift
//  ToDoList
//
//  Created by Александр Федоткин on 22.12.2024.
//

import UIKit
import SnapKit

final class SettingsTableViewCell: UITableViewCell {
    
    //MARK: - Private properties
    
    private let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.poppinsRegular.rawValue, size: 18)
        label.textColor = Colors.whiteColorFirst
        return label
    }()
    
    private let rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.NavigationImages.arrowRight
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.whiteColorFirst
        return view
    }()
    
    //MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension

private extension SettingsTableViewCell {
    
    //MARK: - UI initialization function
    
    func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(leftImageView)
        addSubview(titleLabel)
        addSubview(rightImageView)
        addSubview(bottomSeparatorView)
    }
    
    func setupConstraints() {
        leftImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(17)
            make.right.equalTo(titleLabel.snp.left).offset(-10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(17)
            make.trailing.greaterThanOrEqualTo(rightImageView.snp.leading).inset(10)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
            make.trailing.equalToSuperview().inset(34)
        }
        
        bottomSeparatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

//MARK: - Public extension

extension SettingsTableViewCell {
    
    //MARK: - Setup data
    
    func setupData(_ data: SettingsTableViewModel) {
        leftImageView.image = data.image
        titleLabel.text = data.title
    }
}
