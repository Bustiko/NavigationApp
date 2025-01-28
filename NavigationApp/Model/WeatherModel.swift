//
//  WeatherModel.swift
//  NavigationApp
//
//  Created by Buse Karabıyık on 13.07.2024.
//

import Foundation

struct WeatherModel {
    let temp: Double
    let weatherIconId: Int
    
    var weatherImage: String {
        switch weatherIconId {
        case 200...202:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 700...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "camera.metering.unknown"
        }
    }
}
