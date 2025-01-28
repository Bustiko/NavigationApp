//
//  MapViewUIFunctions.swift
//  NavigationApp
//
//  Created by Buse Karabıyık on 13.07.2024.
//


import UIKit
import MapboxMaps
import MapboxNavigationUIKit
import MapboxDirections
import MapboxNavigationCore

struct MapViewUIFunctions {
    
    let uiFunctions = UIFunctions()
    
    internal mutating func placeButton(on viewController: UIViewController, vehicleSelector: Selector, startSelector: Selector) {
        ViewController.carButton = uiFunctions.makeButton(textSize: 40, withImage: UIImage(systemName: "car.fill"))
        ViewController.walkingButton = uiFunctions.makeButton(textSize: 40, withImage: UIImage(systemName: "figure.walk"))
        ViewController.cyclingButton = uiFunctions.makeButton(textSize: 40, withImage: UIImage(systemName: "bicycle"))
        ViewController.navigationStartButton = uiFunctions.makeButton(withText: "Start Navigation", textSize: 23)
        
        if let navigationStartButton = ViewController.navigationStartButton, let carButton = ViewController.carButton, let walkingButton = ViewController.walkingButton, let cyclingButton = ViewController.cyclingButton {
            
            navigationStartButton.isHidden = true
            carButton.isHidden = true
            walkingButton.isHidden = true
            cyclingButton.isHidden = true
            
            viewController.view.addSubview(navigationStartButton)
            viewController.view.addSubview(carButton)
            viewController.view.addSubview(walkingButton)
            viewController.view.addSubview(cyclingButton)
            
            carButton.addTarget(self, action: vehicleSelector, for: .touchUpInside)
            walkingButton.addTarget(self, action: vehicleSelector, for: .touchUpInside)
            cyclingButton.addTarget(self, action: vehicleSelector, for: .touchUpInside)
            navigationStartButton.addTarget(self, action: startSelector, for: .touchUpInside)
            
            NSLayoutConstraint.activate([
                carButton.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 75),
                carButton.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor, constant: 70),
                carButton.heightAnchor.constraint(equalToConstant: 70),
                carButton.widthAnchor.constraint(equalToConstant: 70),
                
                walkingButton.centerXAnchor.constraint(equalTo: carButton.centerXAnchor, constant: 90),
                walkingButton.centerYAnchor.constraint(equalTo: carButton.centerYAnchor),
                walkingButton.heightAnchor.constraint(equalToConstant: 70),
                walkingButton.widthAnchor.constraint(equalToConstant: 70),
                
                cyclingButton.centerXAnchor.constraint(equalTo: walkingButton.centerXAnchor, constant: 90),
                cyclingButton.centerYAnchor.constraint(equalTo: walkingButton.centerYAnchor),
                cyclingButton.heightAnchor.constraint(equalToConstant: 70),
                cyclingButton.widthAnchor.constraint(equalToConstant: 70),
                
                navigationStartButton.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                navigationStartButton.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor)
            ])
        }
        
    }
    
    
    internal func addZoomRotationControls(on viewController: UIViewController, rotateZoomSelector: Selector) {
        let zoomInButton = uiFunctions.makeButton(withText: "+", textSize: 20)
        zoomInButton.configuration?.cornerStyle = .small
        zoomInButton.addTarget(viewController, action: rotateZoomSelector, for: .touchUpInside)
        viewController.view.addSubview(zoomInButton)
        
        let zoomOutButton = uiFunctions.makeButton(withText: "-", textSize: 20)
        zoomOutButton.configuration?.cornerStyle = .small
        zoomOutButton.addTarget(viewController, action: rotateZoomSelector, for: .touchUpInside)
        viewController.view.addSubview(zoomOutButton)
        
        let rotateLeftButton = uiFunctions.makeButton(withText: "⟲", textSize: 20)
        rotateLeftButton.configuration?.cornerStyle = .small
        rotateLeftButton.addTarget(viewController, action: rotateZoomSelector, for: .touchUpInside)
        viewController.view.addSubview(rotateLeftButton)
        
        let rotateRightButton = uiFunctions.makeButton(withText: "⟳", textSize: 20)
        rotateRightButton.configuration?.cornerStyle = .small
        rotateRightButton.addTarget(viewController, action:rotateZoomSelector, for: .touchUpInside)
        viewController.view.addSubview(rotateRightButton)
        
        let pitchUpButton = uiFunctions.makeButton(withText: "↑", textSize: 15)
        pitchUpButton.configuration?.cornerStyle = .small
        pitchUpButton.addTarget(viewController, action: rotateZoomSelector, for: .touchUpInside)
        viewController.view.addSubview(pitchUpButton)
        
        let pitchDownButton = uiFunctions.makeButton(withText: "↓", textSize: 15)
        pitchDownButton.configuration?.cornerStyle = .small
        pitchDownButton.addTarget(viewController, action: rotateZoomSelector, for: .touchUpInside)
        viewController.view.addSubview(pitchDownButton)
    
        NSLayoutConstraint.activate([
            rotateRightButton.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -20),
            rotateRightButton.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor, constant: -200),
            rotateRightButton.heightAnchor.constraint(equalToConstant: 45),
            rotateRightButton.widthAnchor.constraint(equalToConstant: 45),
            
            rotateLeftButton.centerXAnchor.constraint(equalTo: rotateRightButton.centerXAnchor),
            rotateLeftButton.centerYAnchor.constraint(equalTo: rotateRightButton.centerYAnchor, constant: -40),
            rotateLeftButton.heightAnchor.constraint(equalTo: rotateRightButton.heightAnchor),
            rotateLeftButton.widthAnchor.constraint(equalTo: rotateRightButton.widthAnchor),
            
            zoomOutButton.centerXAnchor.constraint(equalTo: rotateLeftButton.centerXAnchor),
            zoomOutButton.centerYAnchor.constraint(equalTo: rotateLeftButton.centerYAnchor, constant: -40),
            zoomOutButton.heightAnchor.constraint(equalTo: rotateRightButton.heightAnchor),
            zoomOutButton.widthAnchor.constraint(equalTo: rotateRightButton.widthAnchor),
            
            zoomInButton.centerXAnchor.constraint(equalTo: zoomOutButton.centerXAnchor),
            zoomInButton.centerYAnchor.constraint(equalTo: zoomOutButton.centerYAnchor, constant: -40),
            zoomInButton.heightAnchor.constraint(equalTo: rotateRightButton.heightAnchor),
            zoomInButton.widthAnchor.constraint(equalTo: rotateRightButton.widthAnchor),
        
            pitchDownButton.centerXAnchor.constraint(equalTo: zoomOutButton.centerXAnchor),
            pitchDownButton.centerYAnchor.constraint(equalTo: zoomInButton.centerYAnchor, constant: -40),
            pitchDownButton.heightAnchor.constraint(equalTo: rotateRightButton.heightAnchor),
            pitchDownButton.widthAnchor.constraint(equalTo: rotateRightButton.widthAnchor),
            
            pitchUpButton.centerXAnchor.constraint(equalTo: zoomOutButton.centerXAnchor),
            pitchUpButton.centerYAnchor.constraint(equalTo: pitchDownButton.centerYAnchor, constant: -40),
            pitchUpButton.heightAnchor.constraint(equalTo: rotateRightButton.heightAnchor),
            pitchUpButton.widthAnchor.constraint(equalTo: rotateRightButton.widthAnchor)
            
        ])
    }
    
    func changeColors(forButton button: UIButton) {
        if let carButton = ViewController.carButton, let walkingButton = ViewController.walkingButton, let cyclingButton = ViewController.cyclingButton {
            switch button.configuration?.image {
            case UIImage(systemName: "car.fill"):
                carButton.configuration?.baseBackgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
                carButton.configuration?.baseForegroundColor = UIColor(red: 0.25, green: 0.45, blue: 0.62, alpha: 0.85)
                
                walkingButton.configuration?.baseBackgroundColor = UIColor(red: 0.25, green: 0.45, blue: 0.62, alpha: 0.85)
                walkingButton.configuration?.baseForegroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
                
                cyclingButton.configuration?.baseBackgroundColor = UIColor(red: 0.25, green: 0.45, blue: 0.62, alpha: 0.85)
                cyclingButton.configuration?.baseForegroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
            case UIImage(systemName: "figure.walk"):
                walkingButton.configuration?.baseBackgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
                walkingButton.configuration?.baseForegroundColor = UIColor(red: 0.25, green: 0.45, blue: 0.62, alpha: 0.85)
                
                carButton.configuration?.baseBackgroundColor = UIColor(red: 0.25, green: 0.45, blue: 0.62, alpha: 0.85)
                carButton.configuration?.baseForegroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
                
                cyclingButton.configuration?.baseBackgroundColor = UIColor(red: 0.25, green: 0.45, blue: 0.62, alpha: 0.85)
                cyclingButton.configuration?.baseForegroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
                
            case UIImage(systemName: "bicycle"):
                cyclingButton.configuration?.baseBackgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
                cyclingButton.configuration?.baseForegroundColor = UIColor(red: 0.25, green: 0.45, blue: 0.62, alpha: 0.85)
                
                walkingButton.configuration?.baseBackgroundColor = UIColor(red: 0.25, green: 0.45, blue: 0.62, alpha: 0.85)
                walkingButton.configuration?.baseForegroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
                
                carButton.configuration?.baseBackgroundColor = UIColor(red: 0.25, green: 0.45, blue: 0.62, alpha: 0.85)
                carButton.configuration?.baseForegroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
                
            default:
                print("couldn't find image")
                
            }
        }
    }
    
    func addDataPageButton(on viewController: UIViewController, selector: Selector) {
        let button = uiFunctions.makeButton(textSize: 50, withImage: UIImage(systemName: "chart.bar.xaxis"))
        
        viewController.view.addSubview(button)
        
        button.addTarget(viewController, action: selector, for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor, constant: 18),
            button.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -10),
            button.heightAnchor.constraint(equalToConstant: 30),
            button.widthAnchor.constraint(equalToConstant: 60)
        ])
        
    }
}
