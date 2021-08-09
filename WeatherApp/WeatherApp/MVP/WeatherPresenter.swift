//
//  WeatherPresenter.swift
//  WeatherApp
//
//  Created by Nikita Entin on 05.08.2021.
//

import UIKit

protocol WeatherPresenterProtocol: AnyObject {
    
    func fetchData(city: String, completion: @escaping (Weather?, Error?) -> Void)
    func open(_ vc: UIViewController, with navigation: UINavigationController)
}

final class WeatherPresenter: WeatherPresenterProtocol {
    
    private let apiManager = ApiManager()
    
    //MARK: - получение данных
    func fetchData(city: String, completion: @escaping (Weather?, Error?) -> Void) {
        apiManager.fetchWithCoordinates(for: city) { weather, error in
            completion(weather, error)
        }
    }
    //MARK: - открытие второго экрана
    func open(_ vc: UIViewController, with navigation: UINavigationController) {
        navigation.pushViewController(vc, animated: true)
    }
}
