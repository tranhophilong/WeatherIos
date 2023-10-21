//
//  Model.swift
//  Weather
//
//  Created by Long Tran on 19/10/2023.
//

import Foundation


struct Pressure {
    
    let pressureMb: Double
    let pressureIn: Double
    
}

struct Visibility {
    
    let visKm: Double
    let visMil: Double
}

struct FeelsLike {
    
    let feelsLikeC: Double
    let feelsLikeF: Double
    
}

struct Wind {
    
    let windMph: Double
    let windKph: Double
    
}

struct Temp {
    
    let tempC: Double
    let tempF: Double
    
}

struct Coordinates {
    
    let longitude: Double
    let latitude: Double
    
}

struct Astro {
    
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
    
}



struct Weather {
    
    let condition: String
    let nameIconCondition: String
    let time: String
    let temp: Temp
    let isDay: Bool
    let wind: Wind
    let uv: Double
    let feelsLike: FeelsLike
    let visibility: Visibility
    let pressure: Pressure
    
}

struct WeatherLocation{
    let name: String
    let region: String
    let country: String
    let coordinates: Coordinates
    let localTime: String
    var currentWeather: Weather?
    let date: String
    let astro: Astro
    let minTemp: Temp
    let maxTemp: Temp
    let conditionOfDay: String
    let weatherOfHours: [Weather?]
}
