//
//  ButtonsView.swift
//  NavigationApp
//
//  Created by Buse Karabıyık on 6.07.2024.
//

import UIKit
import SwiftUI

class ButtonsView: UIView {
    let uifunctions = UIFunctions()
    
    init(target: UIViewController, carSelector: Selector, walkingSelector: Selector, cyclingSelector: Selector) {
        super.init(frame: .zero)
        setupViews(target: target, carSelector: carSelector, walkingSelector: walkingSelector, cyclingSelector: cyclingSelector)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(target viewController: UIViewController, carSelector: Selector, walkingSelector: Selector, cyclingSelector: Selector) {
        self.backgroundColor = .white
        
        
        NSLayoutConstraint.activate([
            carButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            carButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            carButton.heightAnchor.constraint(equalToConstant: 70),
            carButton.widthAnchor.constraint(equalToConstant: 70),
            walkingButton.centerXAnchor.constraint(equalTo: carButton.centerXAnchor, constant: 100),
            walkingButton.centerYAnchor.constraint(equalTo: carButton.centerYAnchor),
            walkingButton.heightAnchor.constraint(equalToConstant: 70),
            walkingButton.widthAnchor.constraint(equalToConstant: 70),
            cyclingButton.centerXAnchor.constraint(equalTo: walkingButton.centerXAnchor, constant: 100),
            cyclingButton.centerYAnchor.constraint(equalTo: walkingButton.centerYAnchor),
            cyclingButton.heightAnchor.constraint(equalToConstant: 70),
            cyclingButton.widthAnchor.constraint(equalToConstant: 70),
        ])
    }
   
}
