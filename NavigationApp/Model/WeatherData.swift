//
//  WeatherData.swift
//  NavigationApp
//
//  Created by Buse Karabıyık on 13.07.2024.
//

import Foundation

struct WeatherData: Codable {
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
