//
//  ViewController.swift
//  Wild Waves
//
//  Created by Lorenzo on 12/11/2020.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {

    

    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        performRequest()

        //MARK: - Adding Custom Cell to TableView
        
        let nib = UINib.init(nibName: "CustomTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        //MARK: - Video Player
        let url = Bundle.main.url(forResource: "surfVideo", withExtension: "mp4")!
        player = AVPlayer(url: url)
        avpController.player = player
        avpController.view.frame = videoView.layer.bounds
        avpController.videoGravity = AVLayerVideoGravity.resize
        avpController.showsPlaybackControls = false
        videoView.addSubview(avpController.view)
        player.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { (_) in
            self.player.seek(to: CMTime.zero)
            self.player.play()
        }
        
        //MARK: - Title Navbar Logo
        
        let logo = UIImage(named: "navlogo")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            imageView.contentMode = .scaleAspectFit
            imageView.image = logo
        navigationController?.navigationBar.setTitleVerticalPositionAdjustment(-5, for: UIBarMetrics.default)
        self.navigationItem.titleView = imageView
    }
    
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    
    @IBOutlet weak var videoView: UIView!

    var spotData = [SpotData]()
    var weatherData = [WeatherData]()
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=b729cb8a619ffb92a00b53bf2d3656f0&units=metric"
    
    //MARK: - SpotData JSON Helper
    
    func jsonURL(url: String) -> URL {
        let url = URL(string: url)
        return url!
    }
    
    func parse(data: Data) -> [SpotData] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode([SpotData].self, from: data)
            return result
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
    
    func performRequest() {
        let url = jsonURL(url: "https://s3.eu-west-2.amazonaws.com/lpad-public-assets/software-test/all-spots.json")
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else {
                return
            }
            self.spotData = self.parse(data: data)

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
         
            
            
        }
        dataTask.resume()
    }

    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spotData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell

     
        cell?.commonInit(spotData[indexPath.row].spot_name, "logo")
    
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailsView", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsView" {
            let indexPath = sender as! IndexPath
            let view = segue.destination as! DetailsView
            view.countyN = spotData[indexPath.row].county_name
            view.latitude = spotData[indexPath.row].latitude
            view.longitude = spotData[indexPath.row].longitude
            view.spotN = spotData[indexPath.row].spot_name
        }
    }
    
}

//MARK: - WeatherData JSON Helper

extension ViewController {

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
                    self.weatherData.append(weatherData)
                }
                print(self.weatherData)

            }
            task.resume()
        }
    }
    
    
    
    
}
