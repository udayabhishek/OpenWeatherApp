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
    var weatherAPI = WeatherAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherAPI.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        arrayCityNames.removeAll()
        if Globals.shared.arrayCityNames.count == 0 {
            arrayCityNames.append("Bangalore")
        } else {
            arrayCityNames = Globals.shared.arrayCityNames
        }
        
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? WeatherViewController
        destinationVC?.weatherModelForSelectedCity = weatherModelForSelectedCity
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
        weatherAPI.getWeatherDetails(cityName: arrayCityNames[indexPath.row])
    }

    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            arrayCityNames.remove(at: indexPath.row)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}

extension HomeViewController: WeatherAPIDelegate {
    func updateWeatherDetails(weatherAPI: WeatherAPI, weatherModel: WeatherModel) {
        self.weatherModelForSelectedCity = weatherModel
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: "segueToWeatherViewVC", sender: self)
        }
    }
    
    func failedWithError(error: Error) {
        print(error)
    }
}
