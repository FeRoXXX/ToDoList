//
//  SignInView.swift
//  ToDoList
//
//  Created by Александр Федоткин on 16.12.2024.
//

import UIKit
import SnapKit

final class SignInView: UIView {
    
    //MARK: - Private properties
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .applicationLogo
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome Back to DO IT"
        label.font = .systemFont(ofSize: 25, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let supportLabel: UILabel = {
        let label = UILabel()
        label.text = "Have an other productive day !"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var textFieldsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-mail"
        textField.leftViewMode = .always
        textField.leftView = UIImageView(image: .email)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        return textField
    }()
    
    private var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.leftViewMode = .always
        textField.leftView = UIImageView(image: .password)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        return textField
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
            make.height.equalTo(42)
        }
        
        supportLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(26)
            make.height.equalTo(42)
        }
        
        textFieldsStackView.snp.makeConstraints { make in
            make.top.equalTo(supportLabel.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(26)
        }
    }
}
