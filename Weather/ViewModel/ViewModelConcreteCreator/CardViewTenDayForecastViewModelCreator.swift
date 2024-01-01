//
//  CardViewTenDayForecastCreator.swift
//  Weather
//
//  Created by Long Tran on 22/12/2023.
//

import UIKit

class CardViewTenDayForecastViewModelCreator: CardViewForecastViewModelCreator{
    var currentWeather: CurrentWeather
    
    var forecastDatas: [Forecast]
    
    init(currentWeather: CurrentWeather, forecastDatas: [Forecast]) {
        self.currentWeather = currentWeather
        self.forecastDatas = forecastDatas
    }
    
    func createCardViewModel() -> CardViewModel {
        let tenDayForecastViewModel = createContentCardViewModel()
        return CardViewModel(title: "10-DAY FORECAST", icon: UIImage(systemName: "calendar")!, contentCardViewModel: tenDayForecastViewModel )
    }
    
    func createContentCardViewModel() -> ContentCardViewModel {
        let tenDayForecastViewModel = TenDayForecastViewModel(forecastDatas: forecastDatas, currentWeather: currentWeather)
        return tenDayForecastViewModel
    }
    
     
   
}
