//
//  HelpViewController.swift
//  WeatherApp
//
//  Created by Uday Kumar Abhishek . (Service Transformation) on 11/05/21.
//

import UIKit

class HelpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        //this will return keyboard
        self.navigationController?.popViewController(animated: true)
    }
    
}
