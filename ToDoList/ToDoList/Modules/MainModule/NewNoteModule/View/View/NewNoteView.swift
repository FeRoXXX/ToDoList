//
//  NewNoteView.swift
//  ToDoList
//
//  Created by Александр Федоткин on 23.12.2024.
//

import UIKit
import SnapKit
import Combine

final class NewNoteView: UIView {
    
    //MARK: - Private properties
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterialLight)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0.4
        return view
    }()
    
    private var contentView: NewNoteInputView = {
        let view = NewNoteInputView()
        view.backgroundColor = Colors.whiteColorFirst
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        return view
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

private extension NewNoteView {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(blurEffectView)
        addSubview(contentView)
    }
    
    func setupConstraints() {
        
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
}
