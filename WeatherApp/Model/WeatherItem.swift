//
//  WeatherItem.swift
//  WeatherApp
//
//  Created by Uday Kumar Abhishek . (Service Transformation) on 10/05/21.
//

import Foundation

//weather items

struct WeatherItem: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}

//common items

struct Main: Codable {
    let temp: Double
    let humidity: Double
    let tempMax: Double
    let tempMin: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case humidity
        case tempMax = "temp_max"
        case tempMin = "temp_min"
    }
}

struct Weather: Codable {
    let id: Int
    let description: String
}

struct Wind: Codable {
    let speed: Double
}

//forecast items

struct WeatherForecast: Codable {
    let list: [ForcastItem]
}

struct ForcastItem: Codable {
    let dateTime: Double
    let main: Main
    let weather: [Weather]
    let wind: Wind
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case main
        case weather
        case wind
    }
}

