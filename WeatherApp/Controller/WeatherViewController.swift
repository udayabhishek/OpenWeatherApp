//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Uday Kumar Abhishek . (Service Transformation) on 10/05/21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textFieldCityName: UITextField!
    @IBOutlet weak var imageViewWeather: UIImageView!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelTemperatureUnit: UILabel!
    @IBOutlet weak var labelHumidity: UILabel!
    @IBOutlet weak var labelWindSpeed: UILabel!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var tableViewWeatherForecast: UITableView!
    
    var weatherModelForSelectedCity: WeatherModel?
    var forecastModelForSelectedCity: [WeatherModel]?
    var weatherAPI = WeatherAPI()
    var forcastAPI = ForecastAPI()
    let locationManager = CLLocationManager()
    let userDefault = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("CityList.plist")
    let dispatchQueue = DispatchQueue(label: "Weather")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        weatherAPI.delegate = self
        forcastAPI.delegate = self
        textFieldCityName.delegate = self
        
        tableViewWeatherForecast.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "cellWeatherForecast")
        updateUI(weatherModel: weatherModelForSelectedCity)
    }
}

//MARK: -  Button clicks

extension WeatherViewController {
    //MARK: - Search City Name
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        //this will return keyboard
        textFieldCityName.endEditing(true)
        if textFieldCityName.text == "" {
            let alert = Globals.getAlertControllerWith(title: Constant.INFO, message: Constant.TEXTFIELD_EMPTY)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func locationButtonClicked(_ sender: UIButton) {
        textFieldCityName.resignFirstResponder()
        locationManager.requestLocation()
    }
    
    @IBAction func bookmarkButtonClicked(_ sender: UIBarButtonItem) {
        let cityName = labelCity.text!
        var message = ""
        if !(Globals.shared.arrayCityNames.contains(cityName)) {
            Globals.shared.arrayCityNames.append(cityName)
            //            userDefault.set(Globals.shared.arrayCityNames, forKey: "CityNameList")
            message = Constant.BOOKMARKED
        } else {
            message = Constant.BOOKMARKED_FAILED
        }
        let alertController = Globals.getAlertControllerWith(title: Constant.INFO, message:message)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func changeMetric (_ sender: UIButton) {
        if sender.tag == ButtonTag.Metric.rawValue {
            Globals.unit = Unit.Metric.rawValue
            
        } else if sender.tag == ButtonTag.Imperial.rawValue {
            Globals.unit = Unit.Imperial.rawValue
        }
        callAPI()
    }
    
    func callAPI() {
        let cityName = self.labelCity.text!
        dispatchQueue.async {
            self.weatherAPI.getWeatherDetails(cityName: cityName)
        }
        
        dispatchQueue.async {
            self.forcastAPI.getWeatherDetails(cityName: cityName)
            DispatchQueue.main.async {
                self.updateUI(weatherModel: self.weatherModelForSelectedCity)
                
            }
        }
    }
    
    func updateUI(weatherModel: WeatherModel?) {
        if let weatherModel = weatherModel {
            self.imageViewWeather.image = UIImage(systemName: weatherModel.weatherName)
            self.labelTemperature.text = weatherModel.tempratureInString
            self.labelCity.text = weatherModel.cityName
            self.labelHumidity.text = "\(weatherModel.humidity)%"
            
            if Globals.unit == Unit.Metric.rawValue {
                self.labelTemperatureUnit.text = Degree.Centigrade.rawValue
                self.labelWindSpeed.text = "\(weatherModel.windSpeed) \(Metric.Speed)"
            }
            else if Globals.unit == Unit.Imperial.rawValue {
                self.labelTemperatureUnit.text = Degree.Farenheit.rawValue
                self.labelWindSpeed.text = "\(weatherModel.windSpeed) \(Imperial.Speed)"
            }
        }
    }
    
    //TODO: - Yet to implement
    func swipeGesture() {
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
}

//MARK: - CLLocationManager Delegate Methods

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = currentLocation.coordinate.latitude
            let lon = currentLocation.coordinate.longitude
            weatherAPI.getWeatherDetails(lattitude: lat, longitude: lon)
            forcastAPI.getWeatherDetails(lattitude: lat, longitude: lon)
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
            textField.placeholder = Constant.PLACEHOLDER_TEXT
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityName = textField.text {
            self.activityIndicator.startAnimating()
            weatherAPI.getWeatherDetails(cityName: cityName)
            forcastAPI.getWeatherDetails(cityName: cityName)
        }
        textField.text = ""
    }
}

//MARK: - WeatherAPI Delegate Methods

extension WeatherViewController: WeatherAPIDelegate {
    
    func updateWeatherDetails(weatherAPI: WeatherAPI, weatherModel: WeatherModel) {
        weatherModelForSelectedCity = weatherModel
        //updating UI
        DispatchQueue.main.async {
            self.updateUI(weatherModel: weatherModel)
        }
    }
    
    //handling returned error
    func failedWithError(error: Error) {
        print(error)
        let alert = Globals.getAlertControllerWith(title: "Error", message: "Failed to Search weather data")
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - ForecastAPI Delegate Methods

extension WeatherViewController: ForecastAPIDelegate {
    
    func updateWeatherDetails(forecastAPI: ForecastAPI, weatherModel: [WeatherModel]) {
        forecastModelForSelectedCity = weatherModel
        //updating UI
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.tableViewWeatherForecast.reloadData()
        }
    }
}

//MARK: - UI Table View Delegate and DataSource Methods

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let forcastData = forecastModelForSelectedCity {
            return forcastData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellWeatherForecast", for: indexPath) as! WeatherTableViewCell
        if let forcastData = forecastModelForSelectedCity {
            let temp = "\(forcastData[indexPath.row].tempMin) / \(forcastData[indexPath.row].tempMax)"
            cell.labelDay.text = "\(forcastData[indexPath.row].dateInDayFormat)"
            cell.labelTemperature.text = temp
            cell.imageViewWeather.image = UIImage(systemName: forcastData[indexPath.row].weatherName)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
