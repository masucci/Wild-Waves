//
//  SpotData.swift
//  Wild Waves
//
//  Created by Lorenzo on 12/11/2020.
//

import Foundation

struct SpotData: Codable {
    let spot_name: String
    let latitude: Double
    let longitude: Double
    let spot_id: Int
    let county_name: String
}
