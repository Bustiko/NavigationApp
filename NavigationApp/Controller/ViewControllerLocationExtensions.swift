//
//  ViewControllerLocationExtensions.swift
//  NavigationApp
//
//  Created by Buse Karabıyık on 13.07.2024.
//

import UIKit
import MapboxMaps
import MapboxNavigationUIKit
import MapboxDirections
import MapboxNavigationCore

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !(self.presentedViewController is NavigationViewController) {
            navigationStarted = false
            totalSpeed = 0
            speedChange = 0
        }
        if !navigationStarted {return}
        
        if locations.last?.coordinate.latitude.round(to: 3) ==  ViewController.currentDestinationPoint.coordinate.latitude.round(to: 3) && locations.last?.coordinate.longitude.round(to: 3) == ViewController.currentDestinationPoint.coordinate.longitude.round(to: 3) {
            
            print("end of route!")
            let average = totalSpeed/Double(speedChange)
            
            DataStorageManager.shared.addRoute(route: navigationRoutes?.mainRoute.route.description ?? "unknown", averageSpeed: average)
            
            totalSpeed = 0
            speedChange = 0
            locationManager.stopUpdatingLocation()
            locationManager.stopMonitoringSignificantLocationChanges()
            return
        }
        
            if startDate == nil {
                startDate = Date()
            } else {
                currentTimePassed = Date().timeIntervalSince(startDate!)
            }
        
            if startLocation == nil {
                startLocation = locations.first
            } else if let location = locations.last {
                currentTraveledDistance = startLocation!.distance(from: location)
            }
        
        if let currentTraveledDistance = currentTraveledDistance, let currentTimePassed = currentTimePassed {
            currentSpeed = (currentTraveledDistance/currentTimePassed)*3.6
        }
            
            speedChange += 1
            totalSpeed += currentSpeed
            navigationUIFunctions.changeSpeedIndicator(speed: currentSpeed)
            print("🚗❗️current speed is: \(currentSpeed)")
        
        }
}

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
