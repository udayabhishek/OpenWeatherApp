//
//  Global.swift
//  WeatherApp
//
//  Created by Uday Kumar Abhishek . (Service Transformation) on 11/05/21.
//

import Foundation
import UIKit

class Globals {
    static let shared = Globals()
    private init() {}
    
    static var unit = Unit.Metric.rawValue
    static var degree = Degree.Centigrade.rawValue
    var arrayCityNames = [String]()
    let userDefaults = UserDefaults.standard
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







