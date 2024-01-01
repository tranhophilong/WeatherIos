//
//  CardViewAstroForecastViewModelCreator.swift
//  Weather
//
//  Created by Long Tran on 22/12/2023.
//

import UIKit

class CardViewAstroForecastViewModelCreator: CardViewCurrentForecastViewModelCreator{
    
    var currentWeather: CurrentWeather
    
    
    var astroForecast: Astro
    
    init(currentWeather: CurrentWeather, astroForecast: Astro) {
        self.currentWeather = currentWeather
        self.astroForecast = astroForecast
    }
    
    func createCardViewModel() -> CardViewModel {
       
       let forecastViewModel = createForecastViewModel()
        
        if currentWeather.isDay == 1{
            return CardViewModel(title: "SUNSET", icon: UIImage(systemName: "sunset.fill")!, contentCardViewModel: forecastViewModel)
        }else{
            return CardViewModel(title: "SUNRISE", icon: UIImage(systemName: "sunrise.fill")!, contentCardViewModel: forecastViewModel)
        }
    }
    
    func createForecastViewModel() -> ForecastViewModel {
        
        let sunrise = TimeHandler.timeConversion24(time12: astroForecast.sunrise)
        let sunset = TimeHandler.timeConversion24(time12: astroForecast.sunset)
        
        let forcastViewModel = ForecastViewModel()
        var index = ""
        var subDescription = ""
        
        if currentWeather.isDay == 1{
            index = sunset
            subDescription = sunrise
        }else{
            index = sunrise
            subDescription = sunset
        }
        
        return ForecastViewModel(index: index, subDescription: subDescription)
        
    }
    
}
