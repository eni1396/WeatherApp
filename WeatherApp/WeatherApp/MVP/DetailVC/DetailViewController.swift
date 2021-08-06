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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
    
    func configure(for city: String, with weather: Weather) {
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

        [cityImage, stack].forEach {
            view.addSubview($0)
        }
        
         [cityTemperature, cityPressure, cityHumidity, cityCondition, cityWindSpeed, cityWindDirection].forEach {
            $0.font = .systemFont(ofSize: 17)
        }
        
        cityImage.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            maker.width.height.equalTo(200)
        }
        stack.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(cityImage.snp.bottom).offset(70)
        }
    }
}
