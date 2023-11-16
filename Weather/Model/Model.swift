//
//  Model.swift
//  Weather
//
//  Created by Long Tran on 19/10/2023.
//


import Foundation

// MARK: - Forecast
struct Weather: Decodable {
    let location: LocationWeather
    let current: CurrentWeather
    let forecast: Forecast?
   
    enum CodingKeys: String, CodingKey{
        case location
        case current
        case forecast
    }
}


// MARK: - Current
struct CurrentWeather: Decodable {
    let lastUpdated: String
    let tempC, tempF: Double
    let isDay: Int
    let condition: Condition
    let windMph, windKph: Double
    let windDegree: Double
    let windDir: String
    let pressureMB: Double
    let pressureIn: Double
    let humidity, cloud: Double
    let feelslikeC, feelslikeF: Double
    let visKM, visMiles, uv: Double

    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case tempF = "temp_f"
        case isDay = "is_day"
        case condition
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressureMB = "pressure_mb"
        case pressureIn = "pressure_in"
        case humidity, cloud
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case visKM = "vis_km"
        case visMiles = "vis_miles"
        case uv
      }
    
   
}

// MARK: - Condition
struct Condition: Decodable {
    let text, icon: String
    let code: Int
    
    enum CodingKeys: String, CodingKey{
        case text, icon, code
    }
}

// MARK: - ForecastClass
struct Forecast: Decodable {
    let forecastday: [Forecastday]
    
    enum CodingKeys: String, CodingKey{
        case forecastday
    }
}

// MARK: - Forecastday
struct Forecastday: Decodable {
    let date: String
    let day: ForecastDayDetail
    let astro: Astro
    let hour: [ForecastHour]

    enum CodingKeys: String, CodingKey {
        case date
        case day, astro, hour
    }

}

// MARK: - Astro
struct Astro: Decodable {
    let sunrise, sunset, moonrise, moonset: String

    enum CodingKeys: String, CodingKey {
        case sunrise, sunset, moonrise, moonset
    }
}

// MARK: - Day
struct ForecastDayDetail: Decodable {
    let maxtempC, maxtempF, mintempC, mintempF: Double
    let avgtempC, avgtempF, maxwindMph, maxwindKph: Double
    let avgvisKM: Double
    let avgvisMiles, avghumidity: Double

    let condition: Condition
    let uv: Int

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case maxtempF = "maxtemp_f"
        case mintempC = "mintemp_c"
        case mintempF = "mintemp_f"
        case avgtempC = "avgtemp_c"
        case avgtempF = "avgtemp_f"
        case maxwindMph = "maxwind_mph"
        case maxwindKph = "maxwind_kph"
        case avgvisKM = "avgvis_km"
        case avgvisMiles = "avgvis_miles"
        case avghumidity
        case condition, uv
    }
}

// MARK: - Hour
struct ForecastHour: Decodable {
    let time: String
    let tempC, tempF: Double
    let isDay: Int
    let condition: Condition
    let windMph, windKph: Double
    let windDegree: Double
    let windDir: String
    let pressureMB: Int
    let pressureIn: Double
    let humidity, cloud: Double
    let feelslikeC, feelslikeF: Double
    let visKM, visMiles: Double
    let uv: Int

    enum CodingKeys: String, CodingKey {
        case time
        case tempC = "temp_c"
        case tempF = "temp_f"
        case isDay = "is_day"
        case condition
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressureMB = "pressure_mb"
        case pressureIn = "pressure_in"
        case humidity, cloud
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case visKM = "vis_km"
        case visMiles = "vis_miles"
        case uv
    }
}

// MARK: - Location
struct LocationWeather: Decodable {
    let name, region, country: String
    let lat, lon: Double
    let tzID: String
    let localtime: String

    enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
        case tzID = "tz_id"
        case localtime
    }
}

