//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Uday Kumar Abhishek . (Service Transformation) on 10/05/21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var textFieldCityName: UITextField!
    @IBOutlet weak var imageViewWeather: UIImageView!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelTemperatureUnit: UILabel!
    @IBOutlet weak var labelHumidity: UILabel!
    @IBOutlet weak var labelWindSpeed: UILabel!
    @IBOutlet weak var labelCity: UILabel!
    let userDefault = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("CityList.plist")
    var weatherModelForSelectedCity: WeatherModel?
//    var weatherModelForSelectedCity: WeatherModel? {
//        didSet {
////            loadUI()
//        }
//    }
    
    lazy var speedLazy: Double = {
        return 0.0
    }()
    
    var weatherAPI = WeatherAPI()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
        
        weatherAPI.delegate = self
        textFieldCityName.delegate = self
        
//        weatherAPI.getWeatherDetails(cityName: selectedCity!)
        
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeMade(_:)))
        leftRecognizer.direction = .left
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeMade(_:)))
        rightRecognizer.direction = .right
        self.view.addGestureRecognizer(leftRecognizer)
        self.view.addGestureRecognizer(rightRecognizer)
    }
    
    @IBAction func swipeMade(_ sender: UISwipeGestureRecognizer) {
       if sender.direction == .left {
          print("left swipe made")
       }
       if sender.direction == .right {
          print("right swipe made")
        _ = self.navigationController?.popViewController(animated: true)
       }
    }
    
    func loadUI() {
        if let weatherModel = weatherModelForSelectedCity {
            self.imageViewWeather.image = UIImage(systemName: weatherModel.weatherName)
            self.labelTemperature.text = weatherModel.tempratureInString
            self.labelCity.text = weatherModel.cityName
            self.labelHumidity.text = "Humidity \(weatherModel.humidity)%"
            self.labelWindSpeed.text = "Wind Speed \(weatherModel.windSpeed) kmph"
            self.speedLazy = weatherModel.windSpeed
        }
    }
    //    MARK: - save and fetch methods
//        func saveItems() {
//            //using NSEncoder
//            let encoder = PropertyListEncoder()
//            do {
//                let data = try encoder.encode(Globals.shared.arrayCityNames)
//                try data.write(to: dataFilePath!)
//            } catch  {
//                print("error while saving data: \(error)")
//            }
//        }
        
    override func viewWillAppear(_ animated: Bool) {
        loadUI()
    }
    
    //MARK: - Search City Name
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        //this will return keyboard
        textFieldCityName.endEditing(true)
    }
    
    @IBAction func locationButtonClicked(_ sender: UIButton) {
        //this will return keyboard
//        textFieldCityName.endEditing(true)
        textFieldCityName.resignFirstResponder()
//        locationManager.delegate = self

        locationManager.requestLocation()
    }
    
    @IBAction func bookmarkButtonClicked(_ sender: UIButton) {
        let cityName = labelCity.text!
        var message = "failed to bookmark"
        if !(Globals.shared.arrayCityNames.contains(cityName)) {
            Globals.shared.arrayCityNames.append(cityName)
//            saveItems()
//            userDefault.set(Globals.shared.arrayCityNames, forKey: "CityNameList")
            message = "City is bookmarked"
        } else {
            message = "City is aleady bookmarked"
        }
        let alertController = Globals.getAlertControllerWith(title: "Info", message: message)
        self.present(alertController, animated: true, completion: nil)
    }
    

    @IBAction func changeMetric (_ sender: UIButton) {
//        if sender.tag == ButtonTag.Metric.rawValue {
//            Globals.unit = Unit.Metric.rawValue
//            let temp = Double(labelTemperature.text!)
//            let speed = speedLazy
//            let result = imperialToMetric(temp: temp!, speed: speed)
//            updateUI(result)
//
//        } else if sender.tag == ButtonTag.Imperial.rawValue {
//            Globals.unit = Unit.Imperial.rawValue
//            let temp = Double(labelTemperature.text!)
//            let speed = speedLazy
//            let result = metricToImperial(temp: temp!, speed: speed)
//            updateUI(result)
//        }
    }
    
    func updateUI(_ result: (String, String)) {
        self.labelTemperature.text = result.0
        self.labelWindSpeed.text = result.1
        if Globals.unit == Unit.Metric.rawValue {
            self.labelTemperatureUnit.text = "C"
        } else {
            self.labelTemperatureUnit.text = "F"
        }
    }
    
    func metricToImperial(temp: Double, speed: Double) -> (String, String) {
        let degree = (temp * 9/5) + 32
        let speed = speed * 1.609
        return ("\(degree)", "\(speed)")
    }
    
    func imperialToMetric(temp: Double, speed: Double) -> (String, String) {
        let farenheit = (temp - 32) * 5/9
        let speed = speed * 1.609
        return ("\(farenheit)", "\(speed)")
    }
}

//MARK: - CLLocationManager Delegate Methods

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        print(locations[0].coordinate.latitude)
        if let currentLocation = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = currentLocation.coordinate.latitude
            let lon = currentLocation.coordinate.longitude
            print(lat)
            print(lon)
            weatherAPI.getWeatherDetails(lattitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - Text Field Delegate Methods

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Enter City Name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityName = textField.text {
            weatherAPI.getWeatherDetails(cityName: cityName)
//            getWeatherDataFor(city: cityName)
        }
        textField.text = ""
    }
    
//    func getWeatherDataFor(city: String = "") {
//        weatherAPI.getWeatherDetails(cityName: ci)
//    }
}

//MARK: - WeatherAPI Delegate Methods

extension WeatherViewController: WeatherAPIDelegate {

    func updateWeatherDetails(weatherAPI: WeatherAPI, weatherModel: WeatherModel) {
        
        //updating UI
        DispatchQueue.main.async {
            self.imageViewWeather.image = UIImage(systemName: weatherModel.weatherName)
            self.labelTemperature.text = weatherModel.tempratureInString
            self.labelCity.text = weatherModel.cityName
            self.labelHumidity.text = "Humidity \(weatherModel.humidity)%"
            self.labelWindSpeed.text = "Wind Speed \(weatherModel.windSpeed) kmph"
            self.speedLazy = weatherModel.windSpeed
        }
    }
    
    //handling returned error
    func failedWithError(error: Error) {
        print(error)
    }
}


