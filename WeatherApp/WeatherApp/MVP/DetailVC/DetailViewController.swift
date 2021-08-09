//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Nikita Entin on 06.08.2021.
//

import UIKit
import SVGKit

class DetailViewController: UIViewController {
    
    private let cityImage: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        return view
    }()
    private let cityTemperature = UILabel()
    private let cityCondition = UILabel()
    private let cityWindSpeed = UILabel()
    private let cityWindDirection = UILabel()
    private let cityPressure = UILabel()
    private let cityHumidity = UILabel()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cityPressure, cityCondition, cityHumidity, cityTemperature, cityWindDirection, cityWindSpeed])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    private let scroll = UIScrollView()
    
    var weather: Weather?
    var city: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configure()
    }
    
    private func configure() {
        guard let city = city,
              let weather = weather else { return }
        title = city
        cityPressure.text = "Давление: \(weather.pressure) мм рт.ст."
        cityTemperature.text = "Температура: \(weather.temperature) °C"
        cityHumidity.text = "Влажность: \(weather.humidity) %"
        cityCondition.text = "Сейчас: \(weather.localizedCondition)"
        cityWindSpeed.text = "Скорость ветра: \(weather.windSpeed) м/с"
        cityWindDirection.text = weather.localizedWindDirection
        guard let url = URL(string: weather.iconData), let data = try? Data(contentsOf: url) else { return }
        cityImage.image = SVGKImage(data: data).uiImage
    }
    
    private func setupUI() {
        
        // если город уже есть в массиве, кнопка добавления пропадет
        if !Cities.shared.startCities.contains(city ?? "") {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCity(_:)))
        }
        [cityImage, stack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            cityImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cityImage.widthAnchor.constraint(equalToConstant: 200),
            cityImage.heightAnchor.constraint(equalToConstant: 200),
            
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.topAnchor.constraint(equalTo: cityImage.bottomAnchor, constant: 70),
            
        ])
        
         [cityTemperature, cityPressure, cityHumidity, cityCondition, cityWindSpeed, cityWindDirection].forEach {
            $0.font = .systemFont(ofSize: 17)
        }
    }
    
    @objc private func addCity(_ sender: UIBarButtonItem) {
        guard let city = city,
              let weather = weather else { return }
        Cities.shared.add(city: city)
        Cities.shared.addWeather(for: city, weather: weather)
        navigationController?.popViewController(animated: true)
    }
}
