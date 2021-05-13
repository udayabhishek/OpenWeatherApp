//
//  Global.swift
//  WeatherApp
//
//  Created by Uday Kumar Abhishek . (Service Transformation) on 11/05/21.
//

import Foundation
import UIKit

class Globals {
    static var unit = Unit.Metric.rawValue
//    var unit = Unit.Metric.rawValue
    static var degree = Degree.Centigrade.rawValue
    var arrayCityNames = [String]()
    
    static let shared = Globals()
    private init() {}
    
    func clear() {
        arrayCityNames.removeAll()
    }
    
    static func getAlertControllerWith(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (result : UIAlertAction) -> Void in }
        alertController.addAction(okAction)
        return alertController
    }
}

//TODO: - Need to move this to constant
enum Unit: String {
    case Metric = "metric"
    case Imperial = "imperial"
}

enum Degree: String {
    case Centigrade = "C"
    case Farenheit = "F"
}

enum Metric: String {
    case Temprature = "C"
    case Speed = "kmph"
}

enum Imperial: String {
    case Temprature = "F"
    case Speed = "mph"
}




