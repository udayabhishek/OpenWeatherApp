//
//  WeatherItem.swift
//  WeatherApp
//
//  Created by Uday Kumar Abhishek . (Service Transformation) on 10/05/21.
//

import Foundation


struct WeatherItem: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}

struct Main: Codable {
    let temp: Double
    let humidity: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
}

struct Wind: Codable {
    let speed: Double
}
