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
            contentView.addSubview($0)
        }
        
        cityName.snp.makeConstraints { maker in
            maker.top.leading.equalToSuperview().inset(15)
        }
        
        cityTemperature.snp.makeConstraints { maker in
            maker.leading.bottom.equalToSuperview().inset(15)
        }
        
        cityCondition.snp.makeConstraints { maker in
            maker.trailing.bottom.equalToSuperview().inset(15)
            maker.width.lessThanOrEqualTo(130)
        }
    }
}
