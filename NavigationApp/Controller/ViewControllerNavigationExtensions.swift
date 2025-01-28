//
//  ViewControllerNavigationExtensions.swift
//  NavigationApp
//
//  Created by Buse Karabıyık on 17.07.2024.
//

import Foundation
import MapboxNavigationUIKit
import MapboxMaps
import MapboxNavigationCore
import UIKit

extension ViewController:  NavigationViewControllerDelegate {
    func navigationViewControllerDidDismiss(_ navigationViewController: NavigationViewController, byCanceling canceled: Bool) {
        navigationViewController.navigationView.topBannerContainerView.hide(animated: true)
        navigationViewController.navigationView.bottomBannerContainerView.hide(
            animated: true,
            completion: { [weak self] _ in
                navigationViewController.dismiss(animated: false) {
                    guard let self else { return }
                    
                    ViewController.navigationStartButton.isHidden = true
                    
                    self.mapView.delegate = self
                    
                    self.mapView = navigationViewController.navigationMapView
                    
                    self.showCurrentRoute()
                    
                }
            }
        )
    }
}

extension ViewController: NavigationMapViewDelegate {
    
    func navigationMapView(_ navigationMapView: NavigationMapView, userDidLongTap mapPoint: MapPoint) {
        ViewController.currentDestinationPoint = mapPoint
        requestRoute(destination: mapPoint.coordinate, for: .automobile)
    }
    
    func navigationMapView(_ navigationMapView: NavigationMapView, didSelect alternativeRoute: AlternativeRoute) {
        Task {
            guard let selectedRoutes = await self.navigationRoutes?.selecting(alternativeRoute: alternativeRoute)
            else { return }
            self.navigationRoutes = selectedRoutes
        }
    }
}

extension ViewController {
    func requestRoute(destination: CLLocationCoordinate2D, for vehicle: ProfileIdentifier) {
        guard let userLocation = mapView.mapView.location.latestLocation else { return }
        
        let location = CLLocation(
            latitude: userLocation.coordinate.latitude,
            longitude: userLocation.coordinate.longitude
        )
        
        let userWaypoint = Waypoint(
            location: location,
            name: "user"
        )
        
        let destinationWaypoint = Waypoint(coordinate: destination)
        
        let navigationRouteOptions = NavigationRouteOptions(waypoints: [userWaypoint, destinationWaypoint], profileIdentifier: vehicle)
        
        let task = mapboxNavigation.routingProvider().calculateRoutes(options: navigationRouteOptions)
        
        Task { [weak self] in
            switch await task.result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                guard let self else { return }
                navigationRoutes = response
                ViewController.navigationStartButton?.isHidden = false
                ViewController.carButton?.isHidden = false
                ViewController.walkingButton?.isHidden = false
                ViewController.cyclingButton?.isHidden = false
            }
        }
    }
    
}

extension ViewController {
    func presentWindow(for coordinate: CLLocationCoordinate2D) {
       let sheetViewController = DetailViewController()
        sheetViewController.modalPresentationStyle = .pageSheet
        if let sheet = sheetViewController.sheetPresentationController {
            sheet.detents = [
                .custom { context in
                    return context.maximumDetentValue * 0.35
                 }]
            sheet.prefersGrabberVisible = true
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(sheetViewController, animated: true)
        sheetViewController.onStart = {
            self.requestRoute(destination: coordinate, for: .automobile)
            sheetViewController.dismiss(animated: true)
        }
        
    }
    
}
