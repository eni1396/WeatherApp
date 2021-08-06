//
//  WeatherPresenter.swift
//  WeatherApp
//
//  Created by Nikita Entin on 05.08.2021.
//

import Foundation

protocol WeatherDelegate: AnyObject {
    func getWeather(city: String, weather: Weather)
    func showError(error: Error?)
}

final class WeatherPresenter {
    
    let cities = Cities()
    private let apiManager = ApiManager()
    
    
    func fetchData(city: String, completion: @escaping (Weather?, Error?) -> Void) {
        apiManager.fetchWithCoordinates(for: city) { weather, error in
            completion(weather, error)
        }
    }
}
