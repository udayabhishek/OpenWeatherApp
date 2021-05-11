//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Uday Kumar Abhishek . (Service Transformation) on 10/05/21.
//

import UIKit


class WeatherViewController: UIViewController, WeatherAPIDelegate {
    @IBOutlet weak var textFieldCityName: UITextField!
    @IBOutlet weak var imageViewWeather: UIImageView!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelCity: UILabel!
    var weatherAPI = WeatherAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherAPI.delegate = self
        textFieldCityName.delegate = self
    }
    
//MARK: - Search City Name
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        //this will return keyboard
        textFieldCityName.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func updateWeatherDetails(weatherAPI: WeatherAPI, weatherModel: WeatherModel) {
        
        //updating UI
        DispatchQueue.main.async {
            self.labelTemperature.text = weatherModel.tempratureInString
            self.labelCity.text = weatherModel.cityName
            self.imageViewWeather.image = UIImage(systemName: weatherModel.weatherName)
        }
        
    }
    
    //handling returned error
    func failedWithError(error: Error) {
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

//extension WeatherViewController: WeatherAPIDelegate {
//
//    func updateWeatherDetails(weatherModel: WeatherModel) {
//        print(weatherModel.temperature)
//    }
//
//}

