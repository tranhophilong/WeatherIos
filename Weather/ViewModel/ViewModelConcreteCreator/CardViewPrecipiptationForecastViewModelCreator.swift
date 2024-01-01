//
//  CardViewPrecipiptationForecastCreator.swift
//  Weather
//
//  Created by Long Tran on 24/12/2023.
//

import UIKit

class CardViewPrecipiptationForecastViewModelCreator: CardViewCurrentForecastViewModelCreator{
    var currentWeather: CurrentWeather
    
    
    init(currentWeather: CurrentWeather) {
        self.currentWeather = currentWeather
    }
    
    func createForecastViewModel() -> ForecastViewModel {
        let precip =  Int(currentWeather.precipMn)
        return ForecastViewModel(index: String(precip))
    }
    
    func createCardViewModel() -> CardViewModel {
        let  forecastViewModel = createForecastViewModel()
         return CardViewModel(title: "PRECIPIPTATION", icon: UIImage(systemName: "drop.fill")!, contentCardViewModel: forecastViewModel)
    }
    
    
}
