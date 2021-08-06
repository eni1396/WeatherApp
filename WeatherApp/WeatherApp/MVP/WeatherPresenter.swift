//
//  WeatherPresenter.swift
//  WeatherApp
//
//  Created by Nikita Entin on 05.08.2021.
//

import UIKit

protocol WeatherPresenterProtocol: AnyObject {
    var cities: Cities { get }
    
    func fetchData(city: String, completion: @escaping (Weather?, Error?) -> Void)
    func open(vc: UIViewController, navigation: UINavigationController)
}

final class WeatherPresenter: WeatherPresenterProtocol {
    
    var cities = Cities()
    private let apiManager = ApiManager()
    
    func fetchData(city: String, completion: @escaping (Weather?, Error?) -> Void) {
        apiManager.fetchWithCoordinates(for: city) { weather, error in
            completion(weather, error)
        }
    }
    func open(vc: UIViewController, navigation: UINavigationController) {
        navigation.pushViewController(vc, animated: true)
    }
}
