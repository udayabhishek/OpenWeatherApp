//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Uday Kumar Abhishek . (Service Transformation) on 12/05/21.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let cellId = "CellCityName"
    var arrayCityNames = Globals.shared.arrayCityNames
    var weatherModelForSelectedCity: WeatherModel?
    var forecastModelForSelectedCity: [WeatherModel]?
    var weatherAPI = WeatherAPI()
    var forecastAPI = ForecastAPI()
    var queue = DispatchQueue(label: "Dispatch")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherAPI.delegate = self
        forecastAPI.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let array = Globals.shared.userDefaults.array(forKey: "CityNameList") as? [String] {
            arrayCityNames = array
        }
        
        if arrayCityNames.count == 0 {
            arrayCityNames.append("Bangalore")
        } 
        
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? WeatherViewController
        destinationVC?.weatherModelForSelectedCity = weatherModelForSelectedCity
        destinationVC?.forecastModelForSelectedCity = forecastModelForSelectedCity
        
        let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCityNames.count > 0 ? arrayCityNames.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = arrayCityNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.activityIndicator.startAnimating()
        queue.async {
            self.weatherAPI.getWeatherDetails(cityName: self.arrayCityNames[indexPath.row])
        }
        queue.async {
            self.forecastAPI.getWeatherDetails(cityName: self.arrayCityNames[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            arrayCityNames.remove(at: indexPath.row)
            Globals.shared.userDefaults.set(arrayCityNames, forKey: "CityNameList")
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}

extension HomeViewController: WeatherAPIDelegate {
    func updateWeatherDetails(weatherAPI: WeatherAPI, weatherModel: WeatherModel) {
        self.weatherModelForSelectedCity = weatherModel
    }
    
    func failedWithError(error: Error) {
        print(error)
    }
}

extension HomeViewController: ForecastAPIDelegate {
    func updateWeatherDetails(forecastAPI: ForecastAPI, weatherModel: [WeatherModel]) {
        self.forecastModelForSelectedCity = weatherModel
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: "segueToWeatherViewVC", sender: self)
        }
    }
}
