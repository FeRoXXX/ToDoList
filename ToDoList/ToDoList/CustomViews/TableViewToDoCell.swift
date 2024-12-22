//
//  ToDoCollectionCell.swift
//  ToDoList
//
//  Created by Александр Федоткин on 22.12.2024.
//

import UIKit
import SnapKit

final class TableViewToDoCell: UITableViewCell {
    
    //MARK: - Private properties
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Client meeting"
        label.font = UIFont(name: Fonts.poppinsMedium.rawValue, size: 14)
        label.textColor = Colors.blackColorFirst
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Tomorrow | 10:30pm"
        label.font = UIFont(name: Fonts.poppinsRegular.rawValue, size: 10)
        label.textColor = Colors.blackColorFirst
        return label
    }()
    
    private var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .arrowRight
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .complete
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var contentBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    //MARK: - Public properties
    
    var cellSpacing: CGFloat = 0 {
        didSet {
            contentBackgroundView.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(18)
                make.bottom.top.equalToSuperview().inset(cellSpacing)
            }
        }
    }
    
    //MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if leftImageView.isHidden {
            titleLabel.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(9)
                make.leading.equalToSuperview().inset(25)
                make.trailing.greaterThanOrEqualTo(rightImageView.snp.leading).offset(10)
            }
        } else {
            titleLabel.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(9)
                make.leading.equalTo(leftImageView.snp.trailing).offset(12)
                make.trailing.greaterThanOrEqualTo(rightImageView.snp.leading).offset(10)
            }
        }
    }
}

//MARK: - Private extension

private extension TableViewToDoCell {
    
    //MARK: - UI initialization function
    
    func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(contentBackgroundView)
        contentBackgroundView.addSubview(titleLabel)
        contentBackgroundView.addSubview(dateLabel)
        contentBackgroundView.addSubview(rightImageView)
        contentBackgroundView.addSubview(leftImageView)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(9)
            make.leading.equalToSuperview().inset(25)
            make.trailing.greaterThanOrEqualTo(rightImageView.snp.leading).offset(10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(9)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
        }
        
        leftImageView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(15)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.top.equalToSuperview().inset(18)
        }
        
        contentBackgroundView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(18)
            make.top.bottom.equalToSuperview()
        }
        leftImageView.snp.contentHuggingHorizontalPriority = .init(751)
        rightImageView.snp.contentHuggingHorizontalPriority = .init(751)
    }
}

//MARK: - Public extension

extension TableViewToDoCell {
    
    //MARK: - Setup data
    
    func setupData(_ data: ToDoListModel) {
        titleLabel.text = data.title
        dateLabel.text = data.date
        leftImageView.isHidden = data.isComplete ? false : true
    }
}
