//
//  UIViewController + Alert.swift
//  WeatherApp
//
//  Created by Nikita Entin on 06.08.2021.
//

import UIKit

extension UIViewController {
    public func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
