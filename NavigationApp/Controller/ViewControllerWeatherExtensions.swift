//
//  ViewControllerWeatherExtensions.swift
//  NavigationApp
//
//  Created by Buse Karabıyık on 13.07.2024.
//

import UIKit

extension ViewController: WeatherManagerProtocol {
    
    func didGetWeatherData(weather: WeatherModel) {
        DispatchQueue.main.async {
            let textView = self.mainUIFunctions.makeTextLabel(withText: "\(Int(weather.temp)) °C", size: 23)
            textView.textColor = .darkGray
            self.view.addSubview(textView)
            
            if let image = UIImage(systemName: weather.weatherImage) {
                let imageView = UIImageView(image: image)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.tintColor = UIColor(red: 0.25, green: 0.45, blue: 0.62, alpha: 0.85)
                self.view.addSubview(imageView)
                
                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                    imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                    imageView.heightAnchor.constraint(equalToConstant: 60),
                    imageView.widthAnchor.constraint(equalToConstant: 60),
                    
                    textView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor, constant: 65),
                    textView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
                ])
            } else {
                print("Failed to load image: \(weather.weatherImage)")
            }
        }
    }

    
}

