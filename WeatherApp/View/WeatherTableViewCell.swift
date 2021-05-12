//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Uday Kumar Abhishek . (Service Transformation) on 12/05/21.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewWeather: UIImageView!
    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
