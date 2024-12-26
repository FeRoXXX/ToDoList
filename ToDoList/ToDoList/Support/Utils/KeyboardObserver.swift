//
//  KeyboardObserver.swift
//  ToDoList
//
//  Created by Александр Федоткин on 26.12.2024.
//

import UIKit

final class KeyboardObserver {
    
    // MARK: - Private properties
    private var onKeyboardAppear: ((CGFloat, Double, UIView.AnimationOptions) -> Void)?
    private var onKeyboardDisappear: (() -> Void)?
    
    // MARK: - Initialization
    init(onAppear: @escaping (CGFloat, Double, UIView.AnimationOptions) -> Void,
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
        onKeyboardAppear?(keyboardFrame.height, animationDuration, options)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        onKeyboardDisappear?()
    }
}

