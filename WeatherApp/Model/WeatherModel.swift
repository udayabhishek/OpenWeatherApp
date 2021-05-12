//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Uday Kumar Abhishek . (Service Transformation) on 10/05/21.
//

import Foundation

struct WeatherModel {
    let weatherId: Int
    let cityName: String
    let temperature: Double
    let humidity: Double
    let windSpeed: Double
    let tempMax: Double
    let tempMin: Double
    let dateTime: Double
    
    //this will return temp after one decimal point
    var tempratureInString: String {
        return String(format: "%.1f", temperature)
    }
    
    var tempMaxInString: String {
        return String(format: "%.1f", tempMax)
    }
    
    var tempMinInString: String {
        return String(format: "%.1f", tempMin)
    }
    
    var windSpeedInString: String {
        return String(format: "%.1f", windSpeed)
    }
    
    var dateInDayFormat: String {
        let date = Date(timeIntervalSince1970: dateTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, E"
        //dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return dateFormatter.string(from: date)
//        return ""
    }
    
    //this will return weather condition
    var weatherName: String {
        switch weatherId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}



