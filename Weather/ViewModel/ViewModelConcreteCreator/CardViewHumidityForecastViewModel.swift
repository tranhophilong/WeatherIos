//
//  CardViewHumidityForecastViewModel.swift
//  Weather
//
//  Created by Long Tran on 01/01/2024.
//

import UIKit


class CardViewHumidityForecastViewModel: CardViewCurrentForecastViewModelCreator{
    var currentWeather: CurrentWeather
    
    init(currentWeather: CurrentWeather) {
        self.currentWeather = currentWeather
    }
    
    func createForecastViewModel() -> ForecastViewModel {
        let humidity = currentWeather.humidity
        return ForecastViewModel(index: String(humidity))
    }
    
    func createCardViewModel() -> CardViewModel {
        let  forecastViewModel = createForecastViewModel()
        return CardViewModel(title: "HUMIDITY", icon: UIImage(systemName: "humidity.fill")!, contentCardViewModel: forecastViewModel)
    }
    
    
}
