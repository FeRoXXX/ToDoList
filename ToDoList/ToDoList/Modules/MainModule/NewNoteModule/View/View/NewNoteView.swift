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
    
    //MARK: - Deinit
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
}

//MARK: - Private extension

private extension NewNoteView {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
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
    
    //MARK: - Keyboard visible functions
        
    @objc
    func keyboardWillAppear(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        let keyboardHeight = keyboardFrame.height
        
        contentView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(keyboardHeight)
        }
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       options: UIView.AnimationOptions(rawValue: animationCurve << 16),
                       animations: {
            self.layoutIfNeeded()
            
        },
                       completion: nil)
    }
    
    @objc
    func keyboardWillDisappear() {
        contentView.snp.remakeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
}
