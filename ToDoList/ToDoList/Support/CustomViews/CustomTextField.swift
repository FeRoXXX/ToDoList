//
//  CustomTextField.swift
//  ToDoList
//
//  Created by Александр Федоткин on 22.12.2024.
//

import UIKit

final class CustomTextField: UITextField {
    
    var imageColor: UIColor? = nil {
        didSet {
            imageView.tintColor = imageColor
        }
    }
    
    var attributesForPlaceholder: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]
    
    enum ImageDirection {
        case left
        case right
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        return imageView
    }()
    
    func addImage(_ image: UIImage?, imageDirection: ImageDirection) {
        imageView.image = image
        imageView.frame.size = image?.size ?? CGSize(width: 24, height: 24)
        let imageWithPadding = UIView(frame: CGRect(x: 0, y: 0, width: 32 + imageView.frame.width, height: imageView.frame.height))
        imageView.center = imageWithPadding.center
        imageWithPadding.addSubview(imageView)
        switch imageDirection {
        case .right:
            self.rightView = imageWithPadding
            self.rightViewMode = .always
        case .left:
            self.leftView = imageWithPadding
            self.leftViewMode = .always
        }
    }
    
    func addAttributedPlaceholder(_ text: String?) {
        self.attributedPlaceholder = NSAttributedString(string: text ?? "", attributes: attributesForPlaceholder)
    }
}
