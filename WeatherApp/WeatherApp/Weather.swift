//
//  Weather.swift
//  WeatherApp
//
//  Created by Nikita Entin on 06.08.2021.
//

import Foundation

struct Weather {
    let temperature: Int
    private let condition: String
    let windSpeed: Double
    private let windDirection: String
    let pressure: Int
    let humidity: Int
    let iconData: String
    
    var localizedCondition: String {
        switch condition {
        case "clear": return "ясно"
        case "partly-cloudy": return "малооблачно"
        case "cloudy": return "облачно с прояснениями"
        case "overcast": return "пасмурно"
        case "drizzle": return "морось"
        case "light-rain": return "небольшой дождь"
        case "rain": return "дождь"
        case "moderate-rain": return "умеренно сильный дождь"
        case "heavy-rain": return "сильный дождь"
        case "continuous-heavy-rain": return "длительный сильный дождь"
        case "showers": return "ливень"
        case "wet-snow": return "дождь со снегом"
        case "light-snow": return "небольшой снег"
        case "snow": return "снег"
        case "snow-showers": return "снегопад"
        case "hail": return "град"
        case "thunderstorm": return "гроза"
        case "thunderstorm-with-rain": return "дождь с грозой"
        default: return "гроза с градом"
        }
    }
    var localizedWindDirection: String {
        switch windDirection {
        case "nw": return "Ветер северо-западный"
        case "n": return "Ветер северный"
        case "ne": return "Ветер северо-восточный"
        case "e": return "Ветер восточный"
        case "se": return "Ветер юго-восточный"
        case "s": return "Ветер южный"
        case "sw": return "Ветер юго-западный"
        case "w": return "Ветер западный"
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
