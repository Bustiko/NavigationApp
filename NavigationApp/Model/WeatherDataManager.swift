//
//  WeatherDataManager.swift
//  NavigationApp
//
//  Created by Buse Karabıyık on 13.07.2024.
//

import Foundation
import CoreLocation
protocol WeatherManagerProtocol {
    func didGetWeatherData(weather: WeatherModel)
}

struct WeatherDataManager {
    
    var delegate: WeatherManagerProtocol?
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        fetchData(latitude:latitude, longitude: longitude)
    }
    
    private func fetchData(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        guard let apiKey = ProcessInfo.processInfo.environment["WEATHER_API_KEY"], let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric") else {
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
                if let weather = parseJSON(data) {
                    self.delegate?.didGetWeatherData(weather: weather)
                }
            }
        }
        task.resume()
    }
    
    
    private func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            return WeatherModel(temp: decodedData.main.temp, weatherIconId: decodedData.weather[0].id)
        } catch {
            print("Couldn't parse json data")
            return nil
        }
        
    }
    
}
