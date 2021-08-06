//
//  ApiManager.swift
//  WeatherApp
//
//  Created by Nikita Entin on 05.08.2021.
//

import Foundation
import Alamofire
import CoreLocation

struct ApiManager {
    
    func fetchWithCoordinates(for city: String, completion: @escaping (Weather?, Error?) -> Void) {
        CLGeocoder().geocodeAddressString(city) { placemark, error in
            if let error = error {
                completion(nil, error)
            }
            guard let coordinates = placemark?.first?.location?.coordinate else { return }
            let latitude = coordinates.latitude
            let longitude = coordinates.longitude
            fetchWeather(for: city, latitude: latitude, longitude: longitude) { (weather: Weather?, error) in
                completion(weather, error)
            }
        }
    }
    
    private func fetchWeather(for city: String, latitude: Double, longitude: Double, completion: @escaping (Weather?, Error?) -> Void) {
        let path = "https://api.weather.yandex.ru/v2/forecast?lat=\(latitude)&lon=\(longitude)"
        let token = "0edfd784-14d7-4db7-8b02-81a73988c0eb"
        guard let url = URL(string: path) else { return }
        
        let header: HTTPHeaders = ["X-Yandex-API-Key": token, "Content-Type": "application/raw"]
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).response { dataResponse in
            
            if let error = dataResponse.error {
                completion(nil, error)
            }
            
            guard let data = dataResponse.data,
                  let data = try? JSONDecoder().decode(WeatherModel.self, from: data) else { return }
                  let weather = Weather(weather: data)
            completion(weather, nil)
        }
    }
}
