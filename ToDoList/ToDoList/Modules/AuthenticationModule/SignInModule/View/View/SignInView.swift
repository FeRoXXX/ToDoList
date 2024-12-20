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
    
    //MARK: - Private properties
    
    private(set) var textDidTapped: PassthroughSubject<Void, Never> = .init()
    private(set) var signInDidTapped: PassthroughSubject<(email: String?, password: String?), Never> = .init()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .applicationLogo
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let supportLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var textFieldsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 56
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private var emailTextField: TextFieldWithLeftImage = {
        let textField = TextFieldWithLeftImage()
        textField.addImage(.email)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        return textField
    }()
    
    private var passwordTextField: TextFieldWithLeftImage = {
        let textField = TextFieldWithLeftImage()
        textField.addImage(.password)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        return textField
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.background.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.6470588235, blue: 0.9137254902, alpha: 1)
        configuration.background.cornerRadius = 10
        configuration.baseForegroundColor = .white
        button.configuration = configuration
        button.addTarget(self, action: #selector(signInButtonAction), for: .touchUpInside)
        return button
    }()
    
    private var anyAuthenticationMethod: UILabel = {
        let label = UILabel()
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
    
    //MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.insertSublayer(Background.shared.getGradientLayer(frame: frame), at: 0)
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
}

//MARK: - Public extension

extension SignInView {
    
    //MARK: - Setup static text
    
    func setupStaticText(_ data: SignInStaticText) {
        titleLabel.attributedText = data.title
        supportLabel.text = data.support
        emailTextField.placeholder = data.emailPlaceholder
        passwordTextField.placeholder = data.passwordPlaceholder
        signInButton.configuration?.title = data.signInButtonTitle
        anyAuthenticationMethod.attributedText = data.additionalInfo
        anyAuthenticationMethod.addRangeGesture(stringRange: "sign up") { [weak self] in
            self?.textDidTapped.send()
        }
    }
    
    //MARK: - Sign in button action
    
    @objc
    func signInButtonAction() {
        signInDidTapped.send((emailTextField.text, passwordTextField.text))
    }
}
