//
//  NewTaskView.swift
//  ToDoList
//
//  Created by Александр Федоткин on 23.12.2024.
//

import UIKit
import SnapKit
import Combine

final class NewTaskView: UIView {
    
    //MARK: - Public properties
    
    let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterialLight)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0.4
        return view
    }()
    
    var contentView: NewTaskInputView = {
        let view = NewTaskInputView()
        view.backgroundColor = Colors.whiteColorFirst
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        return view
    }()
    
    //MARK: - Private properties
    
    private var keyboardObserver: KeyboardObserver?
    
    //MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupKeyboardObserver()
        addHidingKeyboardGesture()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension

private extension NewTaskView {
    
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
    
    //MARK: - Keyboard observer
    
    private func setupKeyboardObserver() {
         keyboardObserver = KeyboardObserver(
             onAppear: { [weak self] keyboardHeight, animationDuration, options in
                 guard let self else { return }
                 UIView.animate(withDuration: animationDuration, delay: 0, options: options, animations: {
                     self.contentView.snp.remakeConstraints { make in
                         make.bottom.equalToSuperview().inset(keyboardHeight)
                         make.leading.trailing.equalToSuperview()
                     }
                     self.layoutIfNeeded()
                 })
             },
             onDisappear: { [weak self] in
                 guard let self else { return }
                 UIView.animate(withDuration: 0.25) {
                     self.contentView.snp.remakeConstraints { make in
                         make.bottom.equalToSuperview()
                         make.leading.trailing.equalToSuperview()
                     }
                     self.layoutIfNeeded()
                 }
             }
         )
     }
}

//MARK: - Public extension

extension NewTaskView {
    
    //MARK: - Setup task data
    
    func setupTaskData(_ data: TaskDetailsModel) {
        contentView.timeTextField.text = data.time
        contentView.dateTextField.text = data.date
        contentView.taskTitleField.text = data.title
        contentView.descriptionTextView.text = data.description
        contentView.createButton.configuration?.attributedTitle = AttributedString("save", attributes: AttributeContainer([
            .font: UIFont(name: Fonts.poppinsMedium.rawValue, size: 16) ?? .systemFont(ofSize: 16),
            .foregroundColor: Colors.whiteColorFirst
        ]))
    }
}
