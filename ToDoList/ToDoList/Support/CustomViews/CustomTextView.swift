//
//  CustomTextView.swift
//  ToDoList
//
//  Created by Александр Федоткин on 23.12.2024.
//

import UIKit

class CustomTextView: UITextView {

    var leftImage: UIImage? {
        didSet {
            if leftImage != nil {
                self.applyLeftImage(leftImage!)
            }
        }
    }

    fileprivate func applyLeftImage(_ image: UIImage) {
        let image: UIImage = image
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(
            x: 0, y: 10.0, width: image.size.width + 32, height: image.size.height + 10)
        imageView.contentMode = UIView.ContentMode.center
        self.addSubview(imageView)
        self.textContainerInset = UIEdgeInsets(
            top: 10.0, left: image.size.width + 30.0, bottom: 2.0, right: 2.0)
    }
}
