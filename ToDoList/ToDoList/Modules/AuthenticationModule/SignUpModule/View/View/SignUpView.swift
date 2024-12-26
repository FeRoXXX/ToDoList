//
//  SignUpView.swift
//  ToDoList
//
//  Created by Александр Федоткин on 18.12.2024.
//

import UIKit
import SnapKit
import Combine

final class SignUpView: UIView {
    
    enum TextConstants: String {
        case title = "Welcome to DO IT"
        case support = "create an account and Join us now!"
        case fullNamePlaceholder = "Full name"
        case emailPlaceholder = "E-mail"
        case passwordPlaceholder = "Password"
        case signUpButtonTitle = "Sign up"
        case additionalInfo = "Already have an account? sign in"
    }
    
    //MARK: - Private properties
    
    private(set) var textDidTapped: PassthroughSubject<Void, Never> = .init()
    private(set) var signUpDidTapped: PassthroughSubject<(fullName: String?, email: String?, password: String?), Never> = .init()
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
        let stackView = UIStackView(arrangedSubviews: [fullNameTextField, emailTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private var fullNameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.addImage(Images.TextFieldImages.fullName, imageDirection: .left)
        textField.attributesForPlaceholder = [.font: UIFont(name: Fonts.poppinsRegular.rawValue, size: 18) ?? .systemFont(ofSize: 18), .foregroundColor: Colors.blackColorThird]
        textField.backgroundColor = Colors.whiteColorFirst
        textField.addAttributedPlaceholder(TextConstants.fullNamePlaceholder.rawValue)
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        return textField
    }()
    
    private var emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.addImage(Images.TextFieldImages.email, imageDirection: .left)
        textField.attributesForPlaceholder = [.font: UIFont(name: Fonts.poppinsRegular.rawValue, size: 18) ?? .systemFont(ofSize: 18), .foregroundColor: Colors.blackColorThird]
        textField.backgroundColor = Colors.whiteColorFirst
        textField.addAttributedPlaceholder(TextConstants.emailPlaceholder.rawValue)
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        return textField
    }()
    
    private var passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.addImage(Images.TextFieldImages.password, imageDirection: .left)
        textField.attributesForPlaceholder = [.font: UIFont(name: Fonts.poppinsRegular.rawValue, size: 18) ?? .systemFont(ofSize: 18), .foregroundColor: Colors.blackColorThird]
        textField.backgroundColor = Colors.whiteColorFirst
        textField.addAttributedPlaceholder(TextConstants.passwordPlaceholder.rawValue)
        textField.layer.cornerRadius = 5
        textField.isSecureTextEntry = true
        textField.layer.masksToBounds = true
        return textField
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.background.backgroundColor = Colors.lightBlueThird
        configuration.background.cornerRadius = 10
        configuration.baseForegroundColor = Colors.whiteColorFirst
        button.configuration = configuration
        button.setTitle(TextConstants.signUpButtonTitle.rawValue, for: .normal)
        button.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var anyAuthenticationMethod: UILabel = {
        let label = UILabel()
        label.backgroundColor = Colors.clearColor
        label.attributedText = TextConstants.additionalInfo.rawValue.toAttributedString(highlighting: "sign in",
                                                                                        defaultFont: .init(name: Fonts.poppinsMedium.rawValue, size: 14),
                                                                                        highlightedFont: .init(name: Fonts.poppinsMedium.rawValue, size: 14),
                                                                                        alignment: .center,
                                                                                        additionalColor: Colors.lightBlueSecond)
        label.addRangeGesture(stringRange: "sign in") { [weak self] in
            self?.textDidTapped.send()
        }
        return label
    }()
    
    //MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupKeyboardObserver()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.insertSublayer(Background.shared.getGradientLayer(frame: frame), at: 0)
    }
    
    deinit {
        keyboardObserver = nil
    }
}

//MARK: - Private extension

private extension SignUpView {
    
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
        addSubview(signUpButton)
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
        
        signUpButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(31)
            make.top.equalTo(textFieldsStackView.snp.bottom).offset(69)
        }
        
        anyAuthenticationMethod.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(19)
            make.centerX.equalToSuperview()
            make.leading.trailing.greaterThanOrEqualToSuperview().inset(31)
            make.bottom.equalToSuperview().inset(188)
        }
        
        fullNameTextField.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.height.equalTo(emailTextField.snp.height)
            make.height.equalTo(passwordTextField.snp.height)
        }
    }
    
    //MARK: - Button action
    
    @objc
    func signUpButtonAction() {
        signUpDidTapped.send((fullNameTextField.text, emailTextField.text, passwordTextField.text))
    }
    
    func setupKeyboardObserver() {
        keyboardObserver = KeyboardObserver(
            onAppear: { [weak self] duration, options in
                guard let self = self else { return }
                keyboardObserver?.adjustForKeyboardAppearance(view: self, degree: 2, duration: duration, options: options)
            },
            onDisappear: { [weak self] in
                guard let self = self else { return }
                keyboardObserver?.adjustForKeyboardAppearance(view: self, degree: 2, duration: 0.25, options: .curveEaseOut)
            }
        )
    }
}
