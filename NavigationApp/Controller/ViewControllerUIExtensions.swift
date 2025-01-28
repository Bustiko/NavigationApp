//
//  ViewControllerExtensions.swift
//  NavigationApp
//
//  Created by Buse Karabıyık on 13.07.2024.
//

import UIKit
import MapboxMaps
import MapboxNavigationUIKit
import MapboxNavigationCore
import SwiftUI


//MARK: - BUTTON ACTION

extension ViewController {
    
    @objc func vehicleButtonPressed(_ sender: UIButton) {
        uiFunctions.changeColors(forButton: sender)
            switch sender.configuration?.image {
            case UIImage(systemName: "car.fill"):
                requestRoute(destination: ViewController.currentDestinationPoint.coordinate, for: .automobile)
            case UIImage(systemName: "figure.walk"):
                requestRoute(destination: ViewController.currentDestinationPoint.coordinate, for: .walking)
            case UIImage(systemName: "bicycle"):
                requestRoute(destination: ViewController.currentDestinationPoint.coordinate, for: .cycling)
            default:
                print("button with unknown image icon pressed.")
            }
    }

    @objc func zoomRotationButtonTapped(_ sender: UIButton) {
        switch sender.titleLabel?.text {
        case "+": mapView.mapView.camera.ease(to: CameraOptions(zoom: mapView.mapView.mapboxMap.cameraState.zoom + 1), duration: 0.3)
        case "-": mapView.mapView.camera.ease(to: CameraOptions(zoom: mapView.mapView.mapboxMap.cameraState.zoom - 1), duration: 0.3)
        case "⟲": mapView.mapView.camera.ease(to: CameraOptions(bearing: mapView.mapView.mapboxMap.cameraState.bearing - 10), duration: 0.3)
        case "⟳": mapView.mapView.camera.ease(to: CameraOptions(bearing: mapView.mapView.mapboxMap.cameraState.bearing + 10), duration: 0.3)
        case "↑": mapView.mapView.camera.ease(to: CameraOptions(pitch: max(mapView.mapView.mapboxMap.cameraState.pitch - 10, 0)), duration: 0.3)
        case "↓": mapView.mapView.camera.ease(to: CameraOptions(pitch: min(mapView.mapView.mapboxMap.cameraState.pitch + 10, 60)), duration: 0.3)
        default:
            print("unknown button text.")
        }
    }
    
    @objc func dataPageButtonPressed() {
        let vc = UIHostingController(rootView: GraphView())
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    @objc
    func tappedButton(sender: UIButton) {
        guard let navigationRoutes else { return }

        let navigationOptions = NavigationOptions(
            mapboxNavigation: mapboxNavigation,
            voiceController: mapboxNavigationProvider.routeVoiceController,
            eventsManager: mapboxNavigationProvider.eventsManager(),
            predictiveCacheManager: mapboxNavigationProvider.predictiveCacheManager,
            navigationMapView: mapView
        )
        
        let navigationViewController = NavigationViewController(
            navigationRoutes: navigationRoutes,
            navigationOptions: navigationOptions
        )
        navigationViewController.delegate = self
        navigationViewController.modalPresentationStyle = .fullScreen
        navigationUIFunctions.putSpeedIndicator(on: navigationViewController)

        ViewController.navigationStartButton.isHidden = true

        navigationViewController.navigationView.bottomBannerContainerView.hide(animated: false)
        navigationViewController.navigationView.topBannerContainerView.hide(animated: false)

        present(navigationViewController, animated: false) {
            navigationViewController.navigationView.bottomBannerContainerView.show(animated: true)
            navigationViewController.navigationView.topBannerContainerView.show(animated: true)
            self.navigationStarted = true
            self.locationManager.startUpdatingLocation()
            self.locationManager.startMonitoringSignificantLocationChanges()
        }
    }
}

