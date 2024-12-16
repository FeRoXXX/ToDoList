//
//  Background.swift
//  ToDoList
//
//  Created by Александр Федоткин on 16.12.2024.
//

import UIKit

final class Background {
    
    //MARK: - Static properties
    
    static let shared = Background()
    
    //MARK: - Private properties
    
    private var gradientLayer: CAGradientLayer {
        let colorTop = #colorLiteral(red: 0.07058823529, green: 0.3254901961, blue: 0.6666666667, alpha: 1).cgColor
        let colorBottom = #colorLiteral(red: 0.01960784314, green: 0.1411764706, blue: 0.2431372549, alpha: 1).cgColor
        
        let gradient = CAGradientLayer()
        gradient.colors = [colorTop, colorBottom]
        gradient.locations = [0.0, 1.0]
        return gradient
    }
    
    //MARK: - Initialization
    
    private init() {}
    
    //MARK: - Get gradient layer
    
    func getGradientLayer(frame: CGRect) -> CAGradientLayer {
        let gradientLayer = gradientLayer
        gradientLayer.frame = frame
        return gradientLayer
    }
}
