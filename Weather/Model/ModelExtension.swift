//
//  ModelExtension.swift
//  Weather
//
//  Created by Long Tran on 19/10/2023.
//

import Foundation

 enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}


extension Weather{
    
    
    init?(json : [String: Any])  {
        
        guard let cond = json["condition"] as? [String: Any],
              let windMph = json["wind_mph"] as? Double, let windKph = json["wind_kph"] as? Double,
              let uv = json["uv"] as? Double,
              let feelLikeC = json["feelslike_c"] as? Double, let feelLikeF = json["feelslike_f"] as? Double,
              let visKm = json["vis_km"] as? Double, let visMiles = json["vis_miles"] as? Double,
              let pressureIn = json["pressure_in"] as? Double, let pressureMb = json["pressure_mb"] as? Double,
              let tempC = json["temp_c"] as? Double, let tempF = json["temp_f"] as? Double,
             let isDay = json["is_day"] as? Int == 0 ? false : true
        else{
            return nil
        }
        
        
        guard let conditionDes = cond["text"] as? String,
              let nameConditionIcon = cond["icon"] as? String
        else{
            return nil
        }
        
        if let lastUpdate = json["last_updated"] as? String {
            self.time = lastUpdate
        }else if let time = json["time"] as? String{
            self.time = time
        }else{
            self.time = ""
        }
        
        self.condition = conditionDes
        self.nameIconCondition = nameConditionIcon
        
        self.temp = Temp(tempC: tempC, tempF: tempF)
        self.isDay = isDay
        self.wind  = Wind(windMph: windMph, windKph: windKph)
        self.uv = uv
        self.feelsLike = FeelsLike(feelsLikeC: feelLikeC, feelsLikeF: feelLikeF)
        self.visibility = Visibility(visKm: visKm, visMil: visMiles)
        self.pressure = Pressure(pressureMb: pressureMb, pressureIn: pressureIn)
        
                 
    }
}


extension WeatherLocation{
    init?(json : [String: Any])  {
           
            guard  let location = json["location"] as? [String: Any],
              let forecast = json["forecast"] as? [String: [[String: Any]]],
              let astro = forecast["forecastday"]![0]["astro"] as? [String:Any],
              let lstforecastOfHour  = forecast["forecastday"]![0]["hour"] as? Array<[String: Any]>,
              let  forecastOfDay = forecast["forecastday"]![0]["day"] as? [String: Any],
              let condition = forecastOfDay["condition"] as? [String: Any] ,
              let lon = location["lon"] as? Double, let lat = location["lat"] as? Double,
              let currentWeather = json["current"] as? [String: Any],
              let date = forecast["forecastday"]![0]["date"] as? String,
              let name = location["name"] as? String,
              let region = location["region"] as? String,
              let country = location["country"] as? String ,
              let  localTime = location["localtime"] as? String,
              let  minC = forecastOfDay["mintemp_c"] as? Double, let minF = forecastOfDay["mintemp_f"] as? Double,
              let  maxC = forecastOfDay["maxtemp_c"] as? Double, let maxF = forecastOfDay["maxtemp_f"] as? Double,
              let condiontionOfDay = condition["text"] as? String,
              let sunrise = astro["sunrise"] as? String, let sunset = astro["sunset"] as? String,
              let monrise = astro["moonrise"] as? String, let moonset = astro["moonset"] as? String else{
             return nil
        }
        
        self.coordinates = Coordinates(longitude: lon, latitude: lat)
        self.currentWeather = try Weather.init(json: currentWeather)
        self.date = date
        self.name = name
        self.region = region
        self.country = country
        self.localTime = localTime
        self.minTemp = Temp(tempC: minC, tempF: minF)
        self.maxTemp = Temp(tempC: maxC, tempF: maxF)
        self.conditionOfDay = condiontionOfDay
        self.astro = Astro(sunrise: sunrise, sunset: sunset, moonrise: monrise, moonset: moonset)
        self.weatherOfHours =  lstforecastOfHour.map({ data in
            Weather(json: data)
        })
            
    }
    
    
}


