//
//  HourlyForecastItem.swift
//  Weather
//
//  Created by Long Tran on 17/11/2023.
//

import UIKit

struct HourlyForecastItem{
    let time: String
    let imgCondtion: UIImage
    let subCondtion: String
    let degree: String
}


struct TenDayForecastItem{
    let iconCondition: UIImage
    let lowDegree: String
    let highDegree: String
    let time: String
    let subCondtion: String
}


enum TypeForecastItem{
    case uv
    case astro
    case wind
    case precip
    case feelslike
    case humidity
    case visibility
    case pressure
}

struct ForecastItem{
    let title: String
    let icon: UIImage
    let index: String
    let description: String
    let subdescription: String
    let typeForecast : TypeForecastItem
}

struct HeaderWeatherItem{
    let nameLocation: String
    let degree: String
    let conditon: String
    let lowDegree: String
    let highDegree: String
}

struct WeatherItem{
    let location: String
    var time: String
    var condtion: String
    var lowDegree: String
    var highDegree: String
    var currentDegree: String
    let background: UIImage
    
}

struct TempBarItem{
    let isShowCurrentTemp: Bool
    let startPer: CGFloat
    let widthPer: CGFloat
    let startPerPoint: CGFloat
    let gradientColors: [UIColor]
    let gradientLocations: [NSNumber]
}

