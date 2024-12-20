//
//  TextFieldWithLeftImage.swift
//  ToDoList
//
//  Created by Александр Федоткин on 17.12.2024.
//

import UIKit

final class TextFieldWithLeftImage: UITextField {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        return imageView
    }()
    
    func addImage(_ image: UIImage?) {
        imageView.image = image
        imageView.frame.size = image?.size ?? CGSize(width: 24, height: 24)
        let imageWithPadding = UIView(frame: CGRect(x: 0, y: 0, width: 32 + imageView.frame.width, height: imageView.frame.height))
        imageView.center = imageWithPadding.center
        imageWithPadding.addSubview(imageView)
        self.leftView = imageWithPadding
        self.leftViewMode = .always
    }
}

