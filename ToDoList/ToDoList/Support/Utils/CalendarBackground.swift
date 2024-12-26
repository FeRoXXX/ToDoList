//
//  CalendarBackground.swift
//  ToDoList
//
//  Created by Александр Федоткин on 25.12.2024.
//

import UIKit

final class CalendarBackground {
    
    //MARK: - Static properties
    
    static let shared = CalendarBackground()
    
    //MARK: - Private properties
    
    private var gradientLayer: CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [colorTop, colorBottom]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }
    
    private var colorTop: CGColor {
        return UIColor.white.withAlphaComponent(0.4).cgColor
    }
    
    private var colorBottom: CGColor {
        return UIColor.white.withAlphaComponent(0.1).cgColor
    }
    
    //MARK: - Initialization
    
    private init() {}
    
    //MARK: - Get gradient layer
    
    func getGradientLayer(bounds: CGRect) -> CAGradientLayer {
        let gradientLayer = gradientLayer
        gradientLayer.frame = bounds
        return gradientLayer
    }
    
}
