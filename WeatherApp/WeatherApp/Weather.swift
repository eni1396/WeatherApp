//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Nikita Entin on 05.08.2021.
//

import Foundation


struct Weather: Codable {
    let info: Info
    let fact: Fact
}

struct Fact: Codable {
    let temp: Int
    let condition: String
    let wind_speed: Double
    let wind_dir: String
    let pressure_mm: Int
    let humidity: Int
}

struct Info: Codable {
    let tzinfo: Tzinfo
}

struct Tzinfo: Codable {
    let name: String
    let abbr: String
}
