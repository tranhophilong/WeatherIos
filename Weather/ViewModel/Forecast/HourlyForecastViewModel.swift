//
//  HourlyForecastViewModel.swift
//  Weather
//
//  Created by Long Tran on 15/12/2023.
//

import UIKit
import Combine

struct HourlyForecastCellViewModel{
    let time: String
    let imgCondition: UIImage
    let subCondition: String
    let degree: String
}


class HourlyForecastViewModel: ContentCardViewModel{
    
    
    private var hourlyForecastCellViewModels =  [HourlyForecastCellViewModel]()
    private let forecastDatas: [Forecast]
    private let currentWeather: CurrentWeather
    let cellViewModels = PassthroughSubject<[HourlyForecastCellViewModel], Never>()
    
    init(forecastDatas: [Forecast], currentWeather: CurrentWeather){
        self.forecastDatas = forecastDatas
        self.currentWeather = currentWeather
       
    }
      
    func createHourlyForecastCellViewModels(){
 //      index == 0 -> time is "Now"
         var isFirst = true
         var isAddData = false
         let currentHour = Int(TimeHandler.getHour(in: currentWeather.lastUpdated)) ?? 0
 
         for forecast in forecastDatas{
             let forecastDay = forecast.forecastday[0]
             let sunRiseTime = TimeHandler.timeConversion24(time12: forecastDay.astro.sunrise)
             let sunSetTime = TimeHandler.timeConversion24(time12: forecastDay.astro.sunset)
 
             let indexSunrise = TimeHandler.getIndexAstro(in: forecastDay.astro.sunrise)
             let indexSunset = TimeHandler.getIndexAstro(in: forecastDay.astro.sunset)
 
             for forecastHour in forecastDay.hour{
                     let hour = TimeHandler.getHour(in: forecastHour.time)
                     let urlIcon = forecastHour.condition.icon
                     let degree = (String(Int(round(forecastHour.tempC))), String(Int(round(forecastHour.tempF))))
                 let icon = urlIcon.lowercased().contains("day") ? ImageHandler.getNameIcon(of: urlIcon, isday: true) : ImageHandler.getNameIcon(of: urlIcon, isday: false)
                     let chanceOffRain = forecastHour.chanceOfRain
                     var subCondition = ""
                     if chanceOffRain == 0{
                         subCondition = ""
                     }else{
                         subCondition = String(chanceOffRain) + "%"
                     }
                     if Int(hour)! >= currentHour{
                         isAddData = true
                     }
                     if isAddData{
                         if isFirst{
                             let forecastVM = HourlyForecastCellViewModel(time: "Now", imgCondition: UIImage(named: icon)!, subCondition: subCondition, degree: degree.0 + "°")
                             isFirst = false
 
                             hourlyForecastCellViewModels.append(forecastVM)
                         }else{
                             let forecastVM = HourlyForecastCellViewModel(time: hour, imgCondition: UIImage(named: icon)!, subCondition: subCondition, degree: degree.0 + "°")
                             hourlyForecastCellViewModels.append(forecastVM)
                         }
 
                         if Int(hour)! == indexSunrise{
                             let forecastVM = HourlyForecastCellViewModel(time: sunRiseTime, imgCondition: UIImage(named: "sunrise")!, subCondition: "", degree: "Sunrise")
                             hourlyForecastCellViewModels.append(forecastVM)
                         }
 
                         if Int(hour)! == indexSunset{
                             let forecastVM = HourlyForecastCellViewModel(time: sunSetTime, imgCondition: UIImage(named: "sunset")!, subCondition: "", degree: "Sunset")
                             hourlyForecastCellViewModels.append(forecastVM)
                         }
 
                     }
                 if hourlyForecastCellViewModels.count >= 26{
                     return
                 }
             }
             
             cellViewModels.send(hourlyForecastCellViewModels)
         }
    }

}
