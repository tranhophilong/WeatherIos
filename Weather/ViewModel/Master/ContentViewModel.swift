//
//  ContentViewModel.swift
//  Weather
//
//  Created by Long Tran on 03/11/2023.
//

import UIKit
import Combine




class ContentViewModel{
    
    enum BodyContentState{
         case refreshHeaderSubview
         case viewDidScroll
    }
    
    enum FetchDataOutput{
        case fetchDataDidFail
        case fetchDataFinished
        case fetchSuccessDataHeader(forecastDayDetail: ForecastDayDetail, currentWeather: CurrentWeather, locationWeather: LocationWeather)
        case fechSuccessDataBodyContent(cardViewModelCreators: [CardViewModelCreator])
    }
    
    let heightHeader = CurrentValueSubject<CGFloat, Never>(0)
    private var didGetContentOffSetDidScroll: Bool = false
    private var contentOffSetDidScroll: CGFloat = 0
    let bodyContentState = PassthroughSubject<(BodyContentState, CGFloat), Never>()
    let changeLblHeader = PassthroughSubject<(Bool, CGFloat), Never>()
    var cancellabels = Set<AnyCancellable>()
    let fetchDataOutput =  PassthroughSubject<FetchDataOutput, Never>()
    private let nameLocation: String
    private let coordinate: Coordinate?
    
    init(nameLocation: String, coordinate: Coordinate?){
        self.nameLocation = nameLocation
        self.coordinate = coordinate
        
        getDataWeatherLocation(coor: coordinate, nameLocation: nameLocation)
    }
    
//    MARK: - Scroll Action
    func scrollAction(with contentOffset: CGFloat, bodyContentOffsetIsZero: Bool, heightHeaderContent: CGFloat){
        let offset = -contentOffset - STATUS_BAR_HEIGHT()
        if heightHeaderContent + offset - 35.VAdapted > heightHeaderContent/5 && bodyContentOffsetIsZero == true{
            heightHeader.value = heightHeaderContent + offset
            changeLblHeader.send((true, offset))
            if didGetContentOffSetDidScroll{
                bodyContentState.send((.refreshHeaderSubview, 0))
            }
            didGetContentOffSetDidScroll = false
        }else{
            changeLblHeader.send((false, 0))
            if !didGetContentOffSetDidScroll{
                didGetContentOffSetDidScroll = true
                contentOffSetDidScroll = contentOffset
            }
            bodyContentState.send((.viewDidScroll, contentOffSetDidScroll))
        }
    }
    
//    MARK: - DATA
    
    private func getDataWeatherLocation(coor: Coordinate?, nameLocation: String){
        WeatherService.shared.get10NextDayForecastWeather(with: coor, nameLocation: nameLocation)
            .sink {[weak self] complete in
                switch complete{
                case .finished:
                    break
                case .failure(_):
                    self!.fetchDataOutput.send(.fetchDataDidFail)
                }
            } receiveValue: {[weak self] (forecastDays, locationWeather) in
              
                Task{[weak self] in
                    do{
                        var urlCurrentWeather = WeatherService.currentWeatherEndpoint
                        if let  coor = coor{
                            urlCurrentWeather  = urlCurrentWeather + "&q=\(coor.lat),\(coor.lon)"
                        }else{
                            urlCurrentWeather = urlCurrentWeather +  "&q=\(nameLocation)"
                        }
                        let currentWeather = try await WeatherService.shared.fetchCurrentWeather(with: urlCurrentWeather).async()
                        let astro = forecastDays[0].forecastday[0].astro
                        let forecastDayDetail = forecastDays[0].forecastday[0].day
                        self?.fetchDataOutput.send(.fetchSuccessDataHeader(forecastDayDetail: forecastDayDetail, currentWeather: currentWeather, locationWeather: locationWeather))
                        let cardViewModelCreators = self!.createCardViewModelCreator(currentWeather: currentWeather, forecastDatas: forecastDays, astro: astro)
                        self?.fetchDataOutput.send(.fechSuccessDataBodyContent(cardViewModelCreators: cardViewModelCreators))
                        
                    }catch{
                        self!.fetchDataOutput.send(.fetchDataDidFail)
                    }
                }
                
            }.store(in: &cancellabels)

    }
    
    private func createCardViewModelCreator(currentWeather: CurrentWeather, forecastDatas: [Forecast], astro: Astro) -> [CardViewModelCreator]{
      let cardViewTendayForecastVMCreator =  CardViewTenDayForecastViewModelCreator(currentWeather: currentWeather, forecastDatas: forecastDatas)
      let cardViewHourlyForecastVMCreator = CardViewHourlyForecastViewModelCreator(currentWeather: currentWeather, forecastDatas: forecastDatas)
      let cardViewUVForecastVMCreator = CardViewUVForecastViewModelCreator(currentWeather: currentWeather)
      let cardViewAstroForecastVMCreator = CardViewAstroForecastViewModelCreator(currentWeather: currentWeather, astroForecast: astro)
      let cardViewWindForecastVMCreator = CardViewWindForecastCreator(currentWeather: currentWeather)
      let cardViewHumidityForecastVMCreator = CardViewHumidityForecastViewModel(currentWeather: currentWeather)
      let cardViewPrecipiptationForecastVMCreator = CardViewPrecipiptationForecastViewModelCreator(currentWeather: currentWeather)
      let cardViewFeelsLikeForecastVMCreator = CardViewFeelslikeForecastViewModelCreator(currentWeather: currentWeather)
      let cardViewVisForecastVMCreator = CardViewVisForecastViewModelCreator(currentWeather: currentWeather)
      let cardViewPressureForecastVMCreator = CardViewPresureForecastViewModelCreator(currentWeather: currentWeather)
        
      return [cardViewHourlyForecastVMCreator, cardViewTendayForecastVMCreator, cardViewUVForecastVMCreator, cardViewAstroForecastVMCreator, cardViewWindForecastVMCreator, cardViewPrecipiptationForecastVMCreator, cardViewFeelsLikeForecastVMCreator, cardViewHumidityForecastVMCreator, cardViewVisForecastVMCreator, cardViewPressureForecastVMCreator]
    }
    
}
