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
    @IBOutlet weak var labelHumidity: UILabel!
    @IBOutlet weak var labelWindSpeed: UILabel!
    @IBOutlet weak var labelCity: UILabel!
    
    var weatherAPI = WeatherAPI()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldCityName.endEditing(true)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherAPI.delegate = self
        textFieldCityName.delegate = self
    }
    
    //MARK: - Search City Name
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        //this will return keyboard
        textFieldCityName.endEditing(true)
    }
    
    @IBAction func locationButtonClicked(_ sender: UIButton) {
        //this will return keyboard
//        textFieldCityName.endEditing(true)
        locationManager.requestLocation()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
        }
        textField.text = ""
    }
}

//MARK: - WeatherAPI Delegate Methods

extension WeatherViewController: WeatherAPIDelegate {

    func updateWeatherDetails(weatherAPI: WeatherAPI, weatherModel: WeatherModel) {
        
        //updating UI
        DispatchQueue.main.async {
            self.imageViewWeather.image = UIImage(systemName: weatherModel.weatherName)
            self.labelTemperature.text = weatherModel.tempratureInString
            self.labelCity.text = weatherModel.cityName
            self.labelHumidity.text = "Humidity \(weatherModel.humidity)"
            self.labelWindSpeed.text = "Wind Speed \(weatherModel.windSpeed)"
            
        }
    }
    
    //handling returned error
    func failedWithError(error: Error) {
        print(error)
    }
}


