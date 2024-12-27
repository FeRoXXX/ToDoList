//
//  Extension+CGRect.swift
//  ToDoList
//
//  Created by Александр Федоткин on 27.12.2024.
//

import UIKit

extension CGRect {
    
    //MARK: - Get gradient layer
    
    func getGradientLayer(colorTop: CGColor, colorBottom: CGColor, startPoint: CGPoint, endPoint: CGPoint) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [colorTop, colorBottom]
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        let gradientLayer = gradient
        gradientLayer.frame = self
        return gradientLayer
    }
}
