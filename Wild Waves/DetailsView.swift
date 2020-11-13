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
        
        fetchWeather(latitude: latitude, longitude: longitude)
        updateLabel(county: countyN, latitude: latitude, longitude: longitude, spot: spotN)
    }
    
    @IBOutlet weak var countyName: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var spotName: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    var countyN = ""
    var spotN = ""
    var latitude = 0.0
    var longitude = 0.0
    var windspeed = 0.0
    
    var weatherData: WeatherData!
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=b729cb8a619ffb92a00b53bf2d3656f0&units=metric"
    
    func updateLabel(county: String, latitude: Double, longitude: Double, spot: String) {
        countyName.text = county
        latitudeLabel.text = String(latitude)
        longitudeLabel.text = String(longitude)
        spotName.text = spot
    }
    
    func knotConversion(metsec: Double) -> String {
        let value =  metsec * 1.94284
        return String(format: "%.2f", value)
    }
    
}

// https://api.openweathermap.org/data/2.5/weather?appid=b729cb8a619ffb92a00b53bf2d3656f0&units=metric&lat=41.86938356954192&lon=-124.2144472484002

extension DetailsView {

    func fetchWeather(latitude: Double, longitude: Double) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherData? {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(WeatherData.self, from: weatherData)
            return result
        } catch {
            print(error)
        }
        return nil
    }
    
     func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                guard error == nil, let data = data else {
                    return
                }
                if let weatherData = self.parseJSON(data) {
                    self.weatherData = weatherData
                }
                
                DispatchQueue.main.async {
                    self.windSpeedLabel.text = self.knotConversion(metsec: self.weatherData.wind.speed)
                    self.windspeed = Double(self.knotConversion(metsec: self.weatherData.wind.speed)) ?? 0.0
                    if self.windspeed <= 15 {
                        self.levelLabel.text = "Novice"
                    } else if self.windspeed <= 20 {
                        self.levelLabel.text = "Intermediate"
                    } else {
                        self.levelLabel.text = "Expert" 
                    }
                }



            }
            task.resume()
        }
    }
    
    
    
    
}
