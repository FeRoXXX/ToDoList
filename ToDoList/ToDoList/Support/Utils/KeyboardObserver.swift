//
//  KeyboardObserver.swift
//  ToDoList
//
//  Created by Александр Федоткин on 26.12.2024.
//

import UIKit

final class KeyboardObserver {
    
    // MARK: - Private properties
    private var onKeyboardAppear: ((Double, UIView.AnimationOptions) -> Void)?
    private var onKeyboardDisappear: (() -> Void)?
    
    //MARK: - Public properties
    
    private var keyBoardHeight: Double = 0
    
    // MARK: - Initialization
    init(onAppear: @escaping (Double, UIView.AnimationOptions) -> Void,
         onDisappear: @escaping () -> Void) {
        self.onKeyboardAppear = onAppear
        self.onKeyboardDisappear = onDisappear
        subscribeToNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private methods
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        let options = UIView.AnimationOptions(rawValue: animationCurve << 16)
        keyBoardHeight = keyboardFrame.height
        onKeyboardAppear?(animationDuration, options)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        keyBoardHeight = 0
        onKeyboardDisappear?()
    }
    
    //MARK: - Public properties
    
    func adjustForKeyboardAppearance(view: UIView, degree: Double = 1, duration: Double, options: UIView.AnimationOptions) {
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: { [weak self] in
            guard let self else { return }
            view.transform = CGAffineTransform(translationX: 0, y: -keyBoardHeight / degree)
        }, completion: nil)
    }
}

