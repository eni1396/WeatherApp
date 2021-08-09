//
//  Weather.swift
//  WeatherApp
//
//  Created by Nikita Entin on 06.08.2021.
//

import Foundation

//MARK: - структура в более удобном виде
struct Weather {
    let temperature: Int
    private let condition: String
    let windSpeed: Double
    private let windDirection: String
    let pressure: Int
    let humidity: Int
    let iconData: String
    
    //MARK: - Обработка условий
    var localizedCondition: String {
        switch condition {
        case "clear": return "Ясно"
        case "partly-cloudy": return "Малооблачно"
        case "cloudy": return "Облачно с прояснениями"
        case "overcast": return "Пасмурно"
        case "drizzle": return "Морось"
        case "light-rain": return "Небольшой дождь"
        case "rain": return "Дождь"
        case "moderate-rain": return "Умеренно сильный дождь"
        case "heavy-rain": return "Сильный дождь"
        case "continuous-heavy-rain": return "Длительный сильный дождь"
        case "showers": return "Ливень"
        case "wet-snow": return "Дождь со снегом"
        case "light-snow": return "Небольшой снег"
        case "snow": return "Снег"
        case "snow-showers": return "Снегопад"
        case "hail": return "Град"
        case "thunderstorm": return "Гроза"
        case "thunderstorm-with-rain": return "Дождь с грозой"
        default: return "Гроза с градом"
        }
    }
    var localizedWindDirection: String {
        switch windDirection {
        case "nw": return "Ветер: северо-западный"
        case "n": return "Ветер: северный"
        case "ne": return "Ветер: северо-восточный"
        case "e": return "Ветер: восточный"
        case "se": return "Ветер: юго-восточный"
        case "s": return "Ветер: южный"
        case "sw": return "Ветер: юго-западный"
        case "w": return "Ветер: западный"
        default: return "штиль"
        }
    }
    
    init(weather: WeatherModel) {
        temperature = weather.fact.temp
        condition = weather.fact.condition
        windSpeed = weather.fact.windSpeed
        windDirection = weather.fact.windDirection
        pressure = weather.fact.pressure
        humidity = weather.fact.humidity
        iconData = "https://yastatic.net/weather/i/icons/funky/dark/\(weather.fact.icon).svg"
    }
}
