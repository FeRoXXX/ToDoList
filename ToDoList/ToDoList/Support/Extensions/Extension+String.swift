//
//  Extension+String.swift
//  ToDoList
//
//  Created by Александр Федоткин on 19.12.2024.
//

import UIKit

extension String {
    
    func toAttributedString(
        highlighting targetWord: String,
        defaultFont: UIFont?,
        highlightedFont: UIFont?,
        link: URL? = nil,
        alignment: NSTextAlignment = .left,
        baseColor: UIColor = Colors.whiteColorFirst,
        additionalColor: UIColor? = nil
    ) -> NSAttributedString {
        guard let defaultFont else { return NSAttributedString(string: self) }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        
        let attributedString = NSMutableAttributedString(
            string: self,
            attributes: [.font: defaultFont, .paragraphStyle: paragraphStyle, .foregroundColor: baseColor]
        )
        
        let range = (self as NSString).range(of: targetWord)
        
        guard let highlightedFont else { return attributedString }
        
        if range.location != NSNotFound {
            var attributes: [NSAttributedString.Key: Any] = [.font: highlightedFont]
            
            if let link {
                attributes[.link] = link
            }
            
            if let additionalColor {
                attributes[.foregroundColor] = additionalColor
            }
            
            attributedString.addAttributes(attributes, range: range)
        }
        
        return attributedString
    }

}
