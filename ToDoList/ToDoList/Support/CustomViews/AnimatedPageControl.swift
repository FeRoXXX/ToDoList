//
//  AnimatedPageControl.swift
//  ToDoList
//
//  Created by Александр Федоткин on 19.12.2024.
//

import UIKit

class AnimatedPageControl: UIView {
    var numberOfPages: Int = 0 {
        didSet { setupDots() }
    }
    var currentPage: Int = 0 {
        didSet { updateDots() }
    }
    var dotHeight: CGFloat = 8
    var dotWidth: CGFloat = 18
    var selectedDotHeight: CGFloat = 8
    var selectedDotWidth: CGFloat = 33
    var dotSpacing: CGFloat = 9
    var dotColor: UIColor = Colors.whiteColorFirst
    var selectedDotColor: UIColor = Colors.whiteColorFirst

    private var dots: [UIView] = []

    private func setupDots() {
        dots.forEach { $0.removeFromSuperview() }
        dots = (0..<numberOfPages).map { _ in
            let dot = UIView()
            dot.backgroundColor = dotColor
            dot.layer.cornerRadius = dotHeight / 2
            addSubview(dot)
            return dot
        }
        layoutDots()
    }

    private func layoutDots() {
        var previousWidth: CGFloat = 0
        for (index, dot) in dots.enumerated() {
            let height = index == currentPage ? selectedDotHeight : dotHeight
            let width = index == currentPage ? selectedDotWidth : dotWidth
            dot.frame = CGRect(
                x: previousWidth,
                y: 0,
                width: width,
                height: height
            )
            previousWidth += width + dotSpacing
            dot.layer.cornerRadius = height / 2
        }
        frame.size = CGSize(
            width: (selectedDotWidth + dotSpacing) + CGFloat(numberOfPages - 1) * (dotWidth + dotSpacing) - dotSpacing,
            height: dotHeight
        )
    }

    private func updateDots() {
        UIView.animate(withDuration: 0.3) {
            self.layoutDots()
        }
    }
}
