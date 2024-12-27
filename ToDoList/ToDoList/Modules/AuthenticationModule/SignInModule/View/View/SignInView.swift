//
//  SignInView.swift
//  ToDoList
//
//  Created by Александр Федоткин on 16.12.2024.
//

import UIKit
import SnapKit
import Combine

final class SignInView: UIView {
    
    enum TextConstants: String {
        case title = "Welcome Back to DO IT "
        case support = "Have an other productive day !"
        case emailPlaceholder = "E-mail"
        case passwordPlaceholder = "Password"
        case signUpButtonTitle = "Sign in"
        case additionalInfo = "Don’t have an account? sign up"
    }
    
    //MARK: - Private properties
    
    private(set) var textDidTapped: PassthroughSubject<Void, Never> = .init()
    private(set) var signInDidTapped: PassthroughSubject<(email: String?, password: String?), Never> = .init()
    private var keyboardObserver: KeyboardObserver?
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.appImages.appLogo
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = TextConstants.title.rawValue.toAttributedString(highlighting: "DO IT",
                                                                               defaultFont: .init(name: Fonts.poppinsMedium.rawValue, size: 25),
                                                                               highlightedFont: .init(name: Fonts.darumaDropOne.rawValue, size: 25))
        return label
    }()
    
    private let supportLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.poppinsMedium.rawValue, size: 18)
        label.textColor = Colors.whiteColorFirst
        label.text = TextConstants.support.rawValue
        return label
    }()
    
    private lazy var textFieldsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 56
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private var emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.addImage(Images.TextFieldImages.email, imageDirection: .left)
        textField.attributesForPlaceholder = [.font: UIFont(name: Fonts.poppinsRegular.rawValue, size: 18) ?? .systemFont(ofSize: 18), .foregroundColor: Colors.blackColorThird]
        textField.addAttributedPlaceholder(TextConstants.emailPlaceholder.rawValue)
        textField.backgroundColor = Colors.whiteColorFirst
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        return textField
    }()
    
    private var passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.addImage(Images.TextFieldImages.password, imageDirection: .left)
        textField.attributesForPlaceholder = [.font: UIFont(name: Fonts.poppinsRegular.rawValue, size: 18) ?? .systemFont(ofSize: 18), .foregroundColor: Colors.blackColorThird]
        textField.addAttributedPlaceholder(TextConstants.passwordPlaceholder.rawValue)
        textField.backgroundColor = Colors.whiteColorFirst
        textField.layer.cornerRadius = 5
        textField.isSecureTextEntry = true
        textField.layer.masksToBounds = true
        return textField
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.background.backgroundColor = Colors.lightBlueThird
        configuration.background.cornerRadius = 10
        configuration.baseForegroundColor = Colors.whiteColorFirst
        button.configuration = configuration
        button.setTitle(TextConstants.signUpButtonTitle.rawValue, for: .normal)
        button.addTarget(self, action: #selector(signInButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var anyAuthenticationMethod: UILabel = {
        let label = UILabel()
        label.attributedText = TextConstants.additionalInfo.rawValue.toAttributedString(highlighting: "sign up",
                                                                                        defaultFont: .init(name: Fonts.poppinsMedium.rawValue, size: 14),
                                                                                        highlightedFont: .init(name: Fonts.poppinsMedium.rawValue, size: 14),
                                                                                        alignment: .center,
                                                                                        additionalColor: Colors.lightBlueSecond)
        label.addRangeGesture(stringRange: "sign up") { [weak self] in
            self?.textDidTapped.send()
        }
        return label
    }()
    
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
    
    //MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let gradient = frame.getGradientLayer(colorTop: Colors.Background.appBackgroundTop,
                                              colorBottom: Colors.Background.appBackgroundBottom,
                                              startPoint: CGPoint(x: 0, y: 0),
                                              endPoint: CGPoint(x: 0, y: 1))
        layer.insertSublayer(gradient, at: 0)
    }
    
    deinit {
        keyboardObserver = nil
    }
}

//MARK: - Private extension

private extension SignInView {
    
    //MARK: - UI initialization function
    
    func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(supportLabel)
        addSubview(textFieldsStackView)
        addSubview(signInButton)
        addSubview(anyAuthenticationMethod)
    }
    
    func setupConstraints() {
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(36)
            make.height.width.equalTo(83)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(26)
        }
        
        supportLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(26)
        }
        
        textFieldsStackView.snp.makeConstraints { make in
            make.top.equalTo(supportLabel.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(26)
        }
        
        signInButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(31)
            make.top.equalTo(textFieldsStackView.snp.bottom).offset(69)
        }
        
        anyAuthenticationMethod.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(19)
            make.centerX.equalToSuperview()
            make.leading.trailing.greaterThanOrEqualToSuperview().inset(31)
            make.bottom.lessThanOrEqualToSuperview().inset(188)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.height.equalTo(passwordTextField.snp.height)
        }
    }
    
    //MARK: - Sign in button action
    
    @objc
    func signInButtonAction() {
        signInDidTapped.send((emailTextField.text, passwordTextField.text))
    }
    
    func setupKeyboardObserver() {
        keyboardObserver = KeyboardObserver(
            onAppear: { [weak self] keyboardHeight, duration, options in
                guard let self = self else { return }
                UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                    self.logoImageView.snp.remakeConstraints { make in
                        make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(180 - keyboardHeight)
                        make.height.width.equalTo(83)
                        make.centerX.equalToSuperview()
                    }
                    
                    self.anyAuthenticationMethod.snp.remakeConstraints { make in
                        make.top.equalTo(self.signInButton.snp.bottom).offset(19)
                        make.centerX.equalToSuperview()
                        make.leading.trailing.greaterThanOrEqualToSuperview().inset(31)
                        make.bottom.lessThanOrEqualToSuperview().inset(keyboardHeight)
                    }
                    
                    self.layoutIfNeeded()
                })
            },
            onDisappear: { [weak self] in
                guard let self = self else { return }
                
                UIView.animate(withDuration: 0.25) {
                    self.logoImageView.snp.remakeConstraints { make in
                        make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(36)
                        make.height.width.equalTo(83)
                        make.centerX.equalToSuperview()
                    }
                    
                    self.anyAuthenticationMethod.snp.remakeConstraints { make in
                        make.top.equalTo(self.signInButton.snp.bottom).offset(19)
                        make.centerX.equalToSuperview()
                        make.leading.trailing.greaterThanOrEqualToSuperview().inset(31)
                        make.bottom.lessThanOrEqualToSuperview().inset(188)
                    }
                    self.layoutIfNeeded()
                }
            }
        )
    }
}
    
