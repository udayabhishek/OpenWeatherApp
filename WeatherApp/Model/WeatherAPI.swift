//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Uday Kumar Abhishek . (Service Transformation) on 10/05/21.
//

import Foundation
import CoreLocation

protocol WeatherAPIDelegate {
    func updateWeatherDetails(weatherAPI: WeatherAPI,weatherModel: WeatherModel)
    func failedWithError(error: Error)
}

struct WeatherAPI {
    let weatherBaseURL = "\(Globals.baseURL)appid=\(Globals.appID)&units=\(Globals.unit)"
    var delegate: WeatherAPIDelegate?
    
    //get weather details base on city name
    func getWeatherDetails(cityName: String) {
        let url = "\(weatherBaseURL)&q=\(cityName)"
        print(url)
        performRequest(url: url)
    }
    
    //get weather details base on coordinates
    func getWeatherDetails(lattitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let url = "\(weatherBaseURL)&lat=\(lattitude)&lon=\(longitude)"
        print(url)
        performRequest(url: url)
    }
    
    //get data from json data
    func performRequest(url: String) {
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.failedWithError(error: error!)
                    return
                }
                if let data = data {
                    if let weather = self.parseJSON(weatherData: data) {
                        delegate?.updateWeatherDetails(weatherAPI: self, weatherModel: weather)
                    }
                }
            }
            task.resume()
        }
    }
     
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherItem.self, from: weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            let humidity = decodedData.main.humidity
            let windSpeed = decodedData.wind.speed
            
            let weather = WeatherModel(weatherId: id, cityName: name, temperature: temp, humidity: humidity, windSpeed: windSpeed)
            return weather
            
        } catch {
            print(error)
            delegate?.failedWithError(error: error)
            return nil
        }
    }
}
