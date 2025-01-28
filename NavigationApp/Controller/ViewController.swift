//
//  ViewController.swift
//  NavigationApp
//
//  Created by Buse Karabıyık on 4.07.2024.
//

import MapboxDirections
import MapboxMaps
import MapboxNavigationCore
import MapboxNavigationUIKit
import UIKit
import CoreLocation

class ViewController: UIViewController {
    private var cancelables = Set<AnyCancelable>()
    
    let mapboxNavigationProvider = MapboxNavigationProvider(coreConfig: .init())
    lazy var mapboxNavigation = mapboxNavigationProvider.mapboxNavigation
    
    var locationManager = CLLocationManager()
    var weatherManager = WeatherDataManager()
    
    let mainUIFunctions = UIFunctions()
    
    static var navigationStartButton: UIButton!
    static var carButton: UIButton?
    static var walkingButton: UIButton?
    static var cyclingButton: UIButton?
    static var speedIndicator: UILabel?
    var uiFunctions = MapViewUIFunctions()
    var navigationUIFunctions = NavigationUIFunctions()
    
    var startLocation: CLLocation?
       var startDate: Date?
       var currentTraveledDistance: Double?
       var currentTimePassed: Double?
       var currentSpeed = 0.0
       var currentRoute: Route?
       var totalSpeed = 0.0
       var speedChange = 0

    var navigationStarted: Bool = false
    
    static var geoDataManager = GeoDataManager()
    
   static var currentDestinationPoint: MapPoint!

    var mapView: NavigationMapView! {
        didSet {
            if oldValue != nil {
                oldValue.removeFromSuperview()
            }

            mapView.translatesAutoresizingMaskIntoConstraints = false

            view.insertSubview(mapView, at: 0)

            NSLayoutConstraint.activate([
                mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                mapView.topAnchor.constraint(equalTo: view.topAnchor),
                mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        }
    }

    var navigationRoutes: NavigationRoutes? {
        didSet {
            showCurrentRoute()
        }
    }

    func showCurrentRoute() {
        guard let navigationRoutes else {
            mapView.removeRoutes()
            return
        }
        mapView.showcase(navigationRoutes)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        weatherManager.delegate = self
        if let latitude = locationManager.location?.coordinate.latitude, let longitude = locationManager.location?.coordinate.latitude {
            DispatchQueue.main.async {
                self.weatherManager.fetchWeather(latitude: latitude, longitude: longitude)
            }
            
        }

        mapView = .init(
            location: mapboxNavigation.navigation().locationMatching.map(\.location).eraseToAnyPublisher(),
            routeProgress: mapboxNavigation.navigation().routeProgress.map(\.?.routeProgress).eraseToAnyPublisher(),
            predictiveCacheManager: mapboxNavigationProvider.predictiveCacheManager
        )
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.mapView.ornaments.compassView.isHidden = true
        mapView.delegate = self
        mapView.mapView.mapboxMap.loadStyle(StyleURI.standard)
        mapView.puckType = .puck2D(.navigationDefault)

        view.addSubview(mapView)

        let _ = mapView.mapView.gestures.onMapTap.observe { context in
            self.presentWindow(for: context.coordinate)
            ViewController.geoDataManager.fetchPlace(latitude: context.coordinate.latitude, longitude: context.coordinate.longitude)
        }.store(in: &cancelables)
        
        
        uiFunctions.placeButton(on: self, vehicleSelector: #selector(vehicleButtonPressed), startSelector:  #selector(tappedButton))
        uiFunctions.addZoomRotationControls(on: self, rotateZoomSelector: #selector(zoomRotationButtonTapped))
        uiFunctions.addDataPageButton(on: self, selector: #selector(dataPageButtonPressed))

        mapboxNavigation.tripSession().startFreeDrive()
    }
}

