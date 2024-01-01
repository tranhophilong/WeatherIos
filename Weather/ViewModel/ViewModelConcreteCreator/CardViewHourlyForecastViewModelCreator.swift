//
//  CardViewHourlyForecastCreator.swift
//  Weather
//
//  Created by Long Tran on 22/12/2023.
//

import UIKit

class CardViewHourlyForecastViewModelCreator: CardViewForecastViewModelCreator{
    
    
    var currentWeather: CurrentWeather
    
    var forecastDatas: [Forecast]
    

    init(currentWeather: CurrentWeather, forecastDatas: [Forecast]) {
        self.currentWeather = currentWeather
        self.forecastDatas = forecastDatas
    }
    
 
    func createCardViewModel() -> CardViewModel {
        let hourlyForecastViewModel = createContentCardViewModel()
        return CardViewModel(title: "HOURLY FORECAST", icon: UIImage(systemName: "timer")!, contentCardViewModel: hourlyForecastViewModel)
    }
    
    func createContentCardViewModel() -> ContentCardViewModel {
        let hourlyForecastViewModel = HourlyForecastViewModel(forecastDatas: forecastDatas, currentWeather: currentWeather)
       
        return hourlyForecastViewModel
    }
     
}
