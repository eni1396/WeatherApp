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
    var filteredCount: Int { get }
    
    mutating func add(city: String)
    mutating func remove(at index: Int)
    mutating func addWeather(for city: String, weather: Weather)
}

struct Cities: City {
    
    static var shared = Cities()
    
    //MARK: - Стартовые 10 городов
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
    var filteredCities = [String]()
    //MARK: - Словарь с погодой для каждого города
    var weatherForCity = [String : Weather]()
    
    //MARK: - Счетчик элементов в массивах
    var count: Int {
        startCities.count
    }
    var filteredCount: Int {
        filteredCities.count
    }
    
    //MARK: - Добавление/удаление элементов в массиве startCities
    mutating func add(city: String) {
        startCities.append(city)
    }
    
    mutating func remove(at index: Int) {
        startCities.remove(at: index)
    }
    //MARK: - Добавление погоды: город является ключом
    mutating func addWeather(for city: String, weather: Weather) {
        weatherForCity[city.capitalized] = weather
    }
}
