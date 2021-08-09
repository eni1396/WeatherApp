//
//  CurrentCityCellTableViewCell.swift
//  WeatherApp
//
//  Created by Nikita Entin on 06.08.2021.
//

import UIKit

class CurrentCityCell: UITableViewCell {

    private let cityName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    private let cityTemperature: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    private let cityCondition: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupUI()
    }
    
    func confiugre(with city: String, weather: Weather) {
        cityName.text = city
        cityTemperature.text = "Температура \(weather.temperature) °C"
        cityCondition.text = weather.localizedCondition
    }
    
    private func setupUI() {
        [cityName, cityCondition, cityTemperature].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            cityName.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 15),
            cityName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            cityTemperature.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15),
            cityTemperature.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -15),
            
            cityCondition.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -15),
            cityCondition.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -15),
            cityCondition.widthAnchor.constraint(lessThanOrEqualToConstant: 130)
        ])
    }
}
