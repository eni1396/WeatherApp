//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Nikita Entin on 05.08.2021.
//

import Foundation

//MARK: - Модель для парсинга
struct WeatherModel: Codable {
    let fact: Fact
}

struct Fact: Codable {
    let temp: Int
    let icon: String
    let condition: String
    let windSpeed: Double
    let windDirection: String
    let pressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp, icon, condition, humidity
        case windSpeed = "wind_speed"
        case windDirection = "wind_dir"
        case pressure = "pressure_mm"
    }
}
