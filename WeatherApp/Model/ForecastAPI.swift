//
//  ForecastAPI.swift
//  WeatherApp
//
//  Created by Uday Kumar Abhishek . (Service Transformation) on 12/05/21.
//

import Foundation
import CoreLocation

protocol ForecastAPIDelegate {
    func updateWeatherDetails(forecastAPI: ForecastAPI,weatherModel: [WeatherModel])
    func failedWithError(error: Error)
}

struct ForecastAPI {
    let weatherBaseURL = "\(Constant.BASE_URL)\(Constant.FORECAST)appid=\(Constant.APP_ID)"
    var delegate: ForecastAPIDelegate?
    
    //get weather details base on city name
    func getWeatherDetails(cityName: String) {
        let url = "\(weatherBaseURL)&q=\(cityName)&units=\(Globals.unit)"
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
                        delegate?.updateWeatherDetails(forecastAPI: self, weatherModel: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> [WeatherModel]? {
        var arrForcastModel = [WeatherModel]()
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherForecast.self, from: weatherData)
            
            print(decodedData)
            print(decodedData.list[0].main)
            for i in 0 ..< decodedData.list.count {
                //there will be data for every 3 hrs for 5 days, so here only one data for a day is been taken
                if i % 8 == 0 {
                    let id = decodedData.list[i].weather.first!.id
                    let temp = decodedData.list[i].main.temp
                    let humidity = decodedData.list[i].main.humidity
                    let windSpeed = decodedData.list[i].wind.speed
                    let tempMax = decodedData.list[i].main.tempMax
                    let tempMin = decodedData.list[i].main.tempMin
                    let datetime = decodedData.list[i].dateTime
                    
                    let weather = WeatherModel(weatherId: id, cityName: "", temperature: temp, humidity: humidity, windSpeed: windSpeed, tempMax: tempMax, tempMin: tempMin, dateTime: datetime)
                    arrForcastModel.append(weather)
                }
            }
            return arrForcastModel
            
        } catch {
            print(error)
            delegate?.failedWithError(error: error)
            return nil
        }
    }
}

