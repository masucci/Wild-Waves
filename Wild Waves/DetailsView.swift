//
//  DetailsView.swift
//  Wild Waves
//
//  Created by Lorenzo on 13/11/2020.
//

import UIKit

class DetailsView: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabel(county: countyN, latitude: latitude, longitude: longitude, spot: spotN, speed: windspeed)
    }
    
    @IBOutlet weak var countyName: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var spotName: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    var countyN = ""
    var spotN = ""
    var latitude = 0.0
    var longitude = 0.0
    var windspeed = 0.0
    
    
    func updateLabel(county: String, latitude: Double, longitude: Double, spot: String, speed: Double) {
        countyName.text = county
        latitudeLabel.text = String(latitude)
        longitudeLabel.text = String(longitude)
        spotName.text = spot
        windSpeedLabel.text = String(speed)
        
    }
    
}
