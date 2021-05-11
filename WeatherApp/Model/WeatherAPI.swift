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
    let weatherBaseURL = "http://api.openweathermap.org/data/2.5/weather?appid=fae7190d7e6433ec3a45285ffcf55c86&units=metric"
    var delegate: WeatherAPIDelegate?
    
    func getWeatherDetails(cityName: String) {
        //api.openweathermap.org/data/2.5/weather?q=London&appid={API key}
        let url = "\(weatherBaseURL)&q=\(cityName)"
        print(url)
        performRequest(url: url)
    }
    
    func getWeatherDetails(lattitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        //api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
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
//            print(decodedData.name)
//            print(decodedData.main.temp)
//            print(decodedData.weather[0].description)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(weatherId: id, cityName: name, temperature: temp)
            print(weather.weatherName)
            return weather
            
        } catch {
            print(error)
            delegate?.failedWithError(error: error)
            return nil
        }
        
    }
    
    
}
