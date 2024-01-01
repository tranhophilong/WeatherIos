//
//  CardViewFeelslikeForecastCreator.swift
//  Weather
//
//  Created by Long Tran on 24/12/2023.
//

import UIKit

class CardViewFeelslikeForecastViewModelCreator: CardViewCurrentForecastViewModelCreator{
    var currentWeather: CurrentWeather
    
    init(currentWeather: CurrentWeather) {
        self.currentWeather = currentWeather
    }
    
    func createForecastViewModel() -> ForecastViewModel {
        let feelsLike =  Int(currentWeather.feelslikeC)
        return ForecastViewModel(index: String(feelsLike))
    }
    
    func createCardViewModel() -> CardViewModel {
        let  forecastViewModel = createForecastViewModel()
         return CardViewModel(title: "FEELSLIKE", icon: UIImage(systemName: "thermometer.medium")!, contentCardViewModel: forecastViewModel)
    }
    
    
}
