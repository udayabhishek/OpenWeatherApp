//
//  Constant.swift
//  WeatherApp
//
//  Created by Uday Kumar Abhishek . (Service Transformation) on 13/05/21.
//

import Foundation

class Constant {
    static let WEATHER = "weather?"
    static let FORECAST = "forecast?"
    static let BASE_URL = "http://api.openweathermap.org/data/2.5/"
    static let APP_ID = "fae7190d7e6433ec3a45285ffcf55c86"
    static let INFO = "Info"
    static let ERROR = "Error"
    static let BOOKMARKED = "City is bookmarked"
    static let BOOKMARKED_FAILED = "City is bookmarked"
    static let TEXTFIELD_EMPTY = "Enter city name"
    static let SUCCESS_MESSAGE = "Successful"
    static let FAILED_MESSAGE = "Something went wrong"
    static let PLACEHOLDER_TEXT = "City Name"
    
}


enum ButtonTag: Int {
    case Metric = 111
    case Imperial = 222
}
