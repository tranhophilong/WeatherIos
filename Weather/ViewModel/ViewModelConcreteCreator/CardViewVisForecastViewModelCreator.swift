//
//  CardViewVisForecastViewModelCreator.swift
//  Weather
//
//  Created by Long Tran on 24/12/2023.
//

import UIKit

class CardViewVisForecastViewModelCreator: CardViewCurrentForecastViewModelCreator{
    var currentWeather: CurrentWeather
    
    init(currentWeather: CurrentWeather) {
        self.currentWeather = currentWeather
    }
    
    func createForecastViewModel() -> ForecastViewModel {
        let visKM = currentWeather.visKM
        return ForecastViewModel(index: String(visKM))
    }
    
    func createCardViewModel() -> CardViewModel {
        let  forecastViewModel = createForecastViewModel()
         return CardViewModel(title: "VISIBILITY", icon: UIImage(systemName: "eye.fill")!, contentCardViewModel: forecastViewModel)
    }
    
    
}
