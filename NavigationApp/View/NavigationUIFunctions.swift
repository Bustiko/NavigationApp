//
//  NavigationUIFunctions.swift
//  NavigationApp
//
//  Created by Buse Karabıyık on 13.07.2024.
//

import Foundation
import UIKit
import MapboxMaps
import MapboxNavigationUIKit
import MapboxDirections
import MapboxNavigationCore

struct NavigationUIFunctions {
    let uiFunctions = UIFunctions()
    let currentSpeed = 0.0

    func putSpeedIndicator(on navigationViewController: NavigationViewController) {
        
        let label = uiFunctions.makeTextLabel(withText: "\(currentSpeed) kmph", size: 15)
    
        label.backgroundColor = .lightGray
        label.textAlignment = .center
        
        ViewController.speedIndicator = label
        navigationViewController.view.addSubview(label)
       
        
        NSLayoutConstraint.activate([

            label.centerXAnchor.constraint(equalTo: navigationViewController.navigationView.speedLimitView.centerXAnchor, constant: 70),
            label.centerYAnchor.constraint(equalTo: navigationViewController.navigationView.speedLimitView.centerYAnchor)
        ])
        
    }
    
    func changeSpeedIndicator(speed: Double) {
        DispatchQueue.main.async {
            ViewController.speedIndicator?.text = "\(speed.round(to: 1)) kmph"
        }
    }
}

