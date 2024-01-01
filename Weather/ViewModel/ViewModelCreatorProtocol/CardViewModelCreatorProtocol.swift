//
//  CardViewModelProtocol.swift
//  Weather
//
//  Created by Long Tran on 22/12/2023.
//

import Foundation


protocol CardViewModelCreator{
    
    func createCardViewModel() -> CardViewModel

}

protocol CardViewCurrentForecastViewModelCreator: CardViewModelCreator{
    
    var currentWeather: CurrentWeather { get set }
    

    func createForecastViewModel() -> ForecastViewModel
    func createSubViewForecastViewModel() -> SubViewForecastViewModel
}


protocol CardViewForecastViewModelCreator: CardViewModelCreator{
    var currentWeather: CurrentWeather {get set}
    var forecastDatas: [Forecast] {get set}
    
    func createContentCardViewModel() -> ContentCardViewModel
}

extension CardViewCurrentForecastViewModelCreator{
    func createSubViewForecastViewModel() -> SubViewForecastViewModel{
        return SubViewForecastViewModel.self as! SubViewForecastViewModel
    }
}
