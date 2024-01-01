//
//  CardViewWindForecastCreator.swift
//  Weather
//
//  Created by Long Tran on 24/12/2023.
//

import UIKit

class CardViewWindForecastCreator: CardViewCurrentForecastViewModelCreator{
    var currentWeather: CurrentWeather
    
    
    init(currentWeather: CurrentWeather) {
        self.currentWeather = currentWeather
    }
    
    func createForecastViewModel() -> ForecastViewModel {
        let wind = Int(currentWeather.windKph)
        return ForecastViewModel(index: String(wind))
    }
    
    func createCardViewModel() -> CardViewModel {
       let  forecastViewModel = createForecastViewModel()
        return CardViewModel(title: "WIND", icon: UIImage(systemName: "wind")!, contentCardViewModel: forecastViewModel)
    }
    
    
}
