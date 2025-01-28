//
//  GeoData.swift
//  NavigationApp
//
//  Created by Buse Karabıyık on 18.07.2024.
//

import Foundation

struct GeoData: Codable {
    let features: [Feature]
}

struct Feature: Codable {
    let type: String
    let properties: FeatureProperties
}

struct FeatureProperties: Codable {
    let website: String?
    let name: String
    let contact: ContactInfo?
    let categories: [String]
    let formatted: String
}

struct ContactInfo: Codable {
    let phone: String?
}

