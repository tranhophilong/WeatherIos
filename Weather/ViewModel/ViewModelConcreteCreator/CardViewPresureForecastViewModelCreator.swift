//
//  CardViewPresureForecastViewModelCreator.swift
//  Weather
//
//  Created by Long Tran on 24/12/2023.
//

import UIKit

class CardViewPresureForecastViewModelCreator: CardViewCurrentForecastViewModelCreator{
    var currentWeather: CurrentWeather
    
    init(currentWeather: CurrentWeather) {
        self.currentWeather = currentWeather
    }
    
    func createForecastViewModel() -> ForecastViewModel {
        let pressureIn = currentWeather.pressureMB
        return ForecastViewModel(index: String(pressureIn))
    }
    
    func createCardViewModel() -> CardViewModel {
        let  forecastViewModel = createForecastViewModel()
         return CardViewModel(title: "PRESSURE", icon: UIImage(systemName: "gauge.medium")!, contentCardViewModel: forecastViewModel)
    }
    
    
    
}
