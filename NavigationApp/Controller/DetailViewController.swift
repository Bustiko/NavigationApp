//
//  DetailView.swift
//  NavigationApp
//
//  Created by Buse Karabıyık on 18.07.2024.
//

import Foundation
import UIKit


class DetailViewController: UIViewController {
    
    let uiFunctions = UIFunctions()
    
    var onStart: (() -> Void)?

    
    override func viewDidLoad() {
        view.backgroundColor = .white
        ViewController.geoDataManager.delegate = self
    }
    
    @objc private func didPressStart() {
        onStart?()
    }
}

extension DetailViewController: GeoDataManagerDelegateProtocol {
    func didGetPlaceData(_ geoDataModel: GeoDataModel) {
        
        DispatchQueue.main.async {
            let placeNameLabel = self.uiFunctions.makeTextLabel(withText: geoDataModel.name, size: 25)
            let adressLabel = self.uiFunctions.makeTextLabel(withText: geoDataModel.adress, size: 15)
            var categoryLabel: UILabel?
            let websiteLabel = self.uiFunctions.makeTextLabel(withText: "🌐 website: \(geoDataModel.website!)", size: 15)
            let phoneNumberLabel = self.uiFunctions.makeTextLabel(withText: "📞 phone: \(geoDataModel.phoneNumber!)", size: 15)
            
            if geoDataModel.categories.count >= 2 {
                let categories = geoDataModel.categories[1]
                    .replacingOccurrences(of: ".", with: ", ")
                    .replacingOccurrences(of: "_", with: " ")
                categoryLabel = self.uiFunctions.makeTextLabel(withText: "▶︎ \(categories) ◀︎", size: 15)
            }else if geoDataModel.categories.count == 1 {
                let categories = geoDataModel.categories.first!
                    .replacingOccurrences(of: ".", with: ", ")
                    .replacingOccurrences(of: "_", with: " ")
                categoryLabel = self.uiFunctions.makeTextLabel(withText: "▶︎ \(categories) ◀︎", size: 14)
            }else {
                categoryLabel = self.uiFunctions.makeTextLabel(withText: "▶︎ no categories ◀︎", size: 14)
            }
            
           
            let startButton = self.uiFunctions.makeButton(withText: "Go",textSize: 20)
            
            startButton.addTarget(self, action: #selector(self.didPressStart), for: .touchUpInside)
            adressLabel.numberOfLines = 2
            adressLabel.textAlignment = .center
            adressLabel.adjustsFontSizeToFitWidth = true
            placeNameLabel.adjustsFontSizeToFitWidth = true
            placeNameLabel.textAlignment = .center
            categoryLabel!.textAlignment = .center
            websiteLabel.textAlignment = .center
            websiteLabel.adjustsFontSizeToFitWidth = true
            phoneNumberLabel.textAlignment = .center
            
            self.view.addSubview(placeNameLabel)
            self.view.addSubview(adressLabel)
            self.view.addSubview(categoryLabel!)
            self.view.addSubview(startButton)
            self.view.addSubview(websiteLabel)
            self.view.addSubview(phoneNumberLabel)
            
            NSLayoutConstraint.activate([
                placeNameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
                placeNameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                placeNameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                placeNameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
                
                adressLabel.topAnchor.constraint(equalTo: placeNameLabel.bottomAnchor, constant: 20),
                adressLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                adressLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                adressLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
                
                categoryLabel!.topAnchor.constraint(equalTo: adressLabel.bottomAnchor, constant: 15),
                categoryLabel!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                categoryLabel!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                categoryLabel!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
                
                websiteLabel.topAnchor.constraint(equalTo: categoryLabel!.bottomAnchor, constant: 15),
                websiteLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                websiteLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                websiteLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
                
                phoneNumberLabel.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 15),
                phoneNumberLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                phoneNumberLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                phoneNumberLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
                
                startButton.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 20),
                startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                startButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20),
                startButton.heightAnchor.constraint(equalToConstant: 50),
                startButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                startButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
            ])
        }
        
    }
}

