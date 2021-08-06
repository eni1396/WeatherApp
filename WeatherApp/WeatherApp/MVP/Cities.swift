//
//  Cities.swift
//  WeatherApp
//
//  Created by Nikita Entin on 05.08.2021.
//

import Foundation

protocol City {
    var weatherForCity: [String: Weather] { get }
    var count: Int { get }
    
    mutating func add(city: String)
    mutating func remove(at index: Int)
    mutating func addWeather(for city: String, weather: Weather)
}

struct Cities: City {
    
    var startCities = [
        "Москва",
        "Санкт-Петербург",
        "Казань",
        "Калуга",
        "Сочи",
        "Владивосток",
        "Новосибирск",
        "Уфа",
        "Калининград",
        "Севастополь",
    ]
    
    var weatherForCity = [String : Weather]()
    var count: Int {
        return startCities.count
    }
    
    mutating func add(city: String) {
        startCities.append(city)
    }
    
    mutating func remove(at index: Int) {
        startCities.remove(at: index)
    }
    
    mutating func addWeather(for city: String, weather: Weather) {
        weatherForCity[city.capitalized] = weather
    }
}
