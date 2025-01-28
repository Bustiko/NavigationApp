//
//  UIFunctions.swift
//  NavigationApp
//
//  Created by Buse Karabıyık on 5.07.2024.
//

import UIKit

struct UIFunctions {
    
    static var attributeContainer = AttributeContainer()
    
    internal func makeButton(withText text : String? = nil, textSize : CGFloat, withImage image: UIImage? = nil) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.filled()
        UIFunctions.attributeContainer = AttributeContainer()
        
        UIFunctions.attributeContainer.font = .systemFont(ofSize: textSize)
        
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        
        if let txt = text {
            config.attributedTitle = AttributedString(txt, attributes: UIFunctions.attributeContainer)
        }else {
            config.image = image
        }
        
        config.baseBackgroundColor = UIColor(red: 0.25, green: 0.45, blue: 0.62, alpha: 0.85)
        config.baseForegroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1.00)
        
        button.configuration = config
        
        return button
    }
    
    internal func makeTextLabel(withText text: String, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = text
        label.font = .boldSystemFont(ofSize: size)
        label.textColor = .black
        
        return label
    }
}
