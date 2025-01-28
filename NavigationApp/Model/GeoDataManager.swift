//
//  GeoDataManager.swift
//  NavigationApp
//
//  Created by Buse Karabıyık on 18.07.2024.
//

import Foundation
import CoreLocation

protocol GeoDataManagerDelegateProtocol {
    func didGetPlaceData(_ geoDataModel: GeoDataModel)
}

struct GeoDataManager {
    var delegate: GeoDataManagerDelegateProtocol?
    
    func fetchPlace(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        fetchData(latitude:latitude, longitude: longitude)
    }
    
    private func fetchData(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        guard let apiKey = ProcessInfo.processInfo.environment["GEO_DATA_API_KEY"], let url = URL(string: "https://api.geoapify.com/v2/place-details?lat=\(latitude)&lon=\(longitude)&apiKey=\(apiKey)") else {
            print("Invalid URL")
            return
        }
        
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            if let data = data {
                if let geoDataModel = parseJSON(data) {
                    print(geoDataModel)
                    self.delegate?.didGetPlaceData(geoDataModel)
                }
            }
        }
        task.resume()
    }
    
    
    private func parseJSON(_ geoData: Data) -> GeoDataModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(GeoData.self, from: geoData)
            if let feature = decodedData.features.first {
                return GeoDataModel(website: feature.properties.website ?? "no info", name: feature.properties.name, phoneNumber: feature.properties.contact?.phone ?? "no info",categories: feature.properties.categories, adress: feature.properties.formatted)
            }
           
        } catch {
            print("Couldn't parse json data")
        }
        return GeoDataModel(website: "no info", name: "NO DATA", phoneNumber: "no info",categories: ["no categories"], adress: "No data found for the selected place.")
    }
}
