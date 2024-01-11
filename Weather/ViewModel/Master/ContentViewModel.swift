//
//  ContentViewModel.swift
//  Weather
//
//  Created by Long Tran on 03/11/2023.
//

import UIKit
import Combine




class ContentViewModel{
      
    enum EventInput{
        case viewDidLoad
        case scroll(contentOffSet: CGFloat, bodyContentOffSetIsZero: Bool, heightHeaderContent: CGFloat)
    }
    
    enum EventOutput{
        case fetchDataDidFail
        case fetchDataFinished
        case fetchSuccessDataHeader(forecastDayDetail: ForecastDayDetail, currentWeather: CurrentWeather, locationWeather: LocationWeather)
        case fechSuccessDataBodyContent(cardViewModelCreators: [CardViewModelCreator])
        case changeHeightHeader(isChange: Bool, height: CGFloat)
        case refreshBody(isRefresh: Bool)
        case isHiddenEffectsLblHeader(isHiddenEffects: Bool, offset: CGFloat)
        case isScrollToHeader(isScrollTo: Bool, offset: CGFloat)
        
    }
   
    private var isGetContentOffSetDidScroll: Bool = false
    private var contentOffSetDidScroll: CGFloat = 0
    var cancellables = Set<AnyCancellable>()
    let weatherSummary = PassthroughSubject<WeatherSummary, Never>()
    let isLoadFinished = CurrentValueSubject<Bool, Never>(false)
    private let eventOutput =  PassthroughSubject<EventOutput, Never>()
    private let nameLocation: String
    private let coordinate: Coordinate?
    
    init(nameLocation: String, coordinate: Coordinate?){
        self.nameLocation = nameLocation
        self.coordinate = coordinate
        
    }
    
    func transform(input: AnyPublisher<EventInput, Never>) -> AnyPublisher<EventOutput, Never>{
        input.sink {  [weak self]  event  in
            switch event{
            case .viewDidLoad:
                self?.createBlankWeatherSummary(coordinate: self!.coordinate, nameLocation: self!.nameLocation)
                self?.getDataWeatherLocation(coor: self!.coordinate, nameLocation: self!.nameLocation)
            case .scroll(contentOffSet: let contentOffSet, bodyContentOffSetIsZero: let bodyContentOffSetIsZero, heightHeaderContent: let heightHeaderContent):
                self?.scrollAction(with: contentOffSet, bodyContentOffsetIsZero: bodyContentOffSetIsZero, heightHeaderContent: heightHeaderContent)
                
            }
            }.store(in: &cancellables)
        
        return eventOutput.eraseToAnyPublisher()
    }
    
//    MARK: - Scroll Action
   private func scrollAction(with contentOffset: CGFloat, bodyContentOffsetIsZero: Bool, heightHeaderContent: CGFloat){
        let offset = -contentOffset - STATUS_BAR_HEIGHT()
        if heightHeaderContent + offset - 25.VAdapted  >= heightHeaderContent/5 && bodyContentOffsetIsZero == true{
            let heightHeader = heightHeaderContent + offset
            eventOutput.send(.changeHeightHeader(isChange: true, height: heightHeader))
            eventOutput.send(.isHiddenEffectsLblHeader(isHiddenEffects: true, offset: offset))
            if isGetContentOffSetDidScroll{
                eventOutput.send(.refreshBody(isRefresh: true))
            }
            isGetContentOffSetDidScroll = false
        }else{
            eventOutput.send(.changeHeightHeader(isChange: false, height: 0))
            eventOutput.send(.isHiddenEffectsLblHeader(isHiddenEffects: false, offset: 0))
            if !isGetContentOffSetDidScroll{
                eventOutput.send(.isHiddenEffectsLblHeader(isHiddenEffects: true, offset: offset))
                isGetContentOffSetDidScroll = true
                contentOffSetDidScroll = contentOffset
            }
            eventOutput.send(.isScrollToHeader(isScrollTo: true, offset: contentOffSetDidScroll))
        }
    }
    
//    MARK: - DATA
    
    func getDataWeatherLocation(coor: Coordinate?, nameLocation: String){
        WeatherService.shared.get10NextDayForecastWeather(with: coor, nameLocation: nameLocation)
            .sink {[weak self] complete in
                switch complete{
                case .finished:
                    self!.isLoadFinished.value = true
                case .failure(_):
                    self!.eventOutput.send(.fetchDataDidFail)
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
                        self?.eventOutput.send(.fetchSuccessDataHeader(forecastDayDetail: forecastDayDetail, currentWeather: currentWeather, locationWeather: locationWeather))
                        let cardViewModelCreators = self!.createCardViewModelCreators(currentWeather: currentWeather, forecastDatas: forecastDays, astro: astro)
                        self?.eventOutput.send(.fechSuccessDataBodyContent(cardViewModelCreators: cardViewModelCreators))
                        let weatherSummary = self!.createWeatherSummary(currentWeather: currentWeather, locationWeather: locationWeather, forecastDayDetail: forecastDayDetail)
                        self?.weatherSummary.send(weatherSummary)
                        
                    }catch{
                        self!.eventOutput.send(.fetchDataDidFail)
                    }
                }
                
            }.store(in: &cancellables)

    }
    
    private func createBlankWeatherSummary(coordinate: Coordinate?, nameLocation: String){
        
        guard let coordinate = coordinate else{
            weatherSummary.send(WeatherSummary(location: nameLocation, maxTempC: nil, maxTempF: nil, minTempC: nil, minTempF: nil, time: nil, condition: nil, currentDegreeF: nil, currentDegreeC: nil))
            return
        }
    
        weatherSummary.send(WeatherSummary(location: "My location", maxTempC: nil, maxTempF: nil, minTempC: nil, minTempF: nil, time: nil, condition: nil, currentDegreeF: nil, currentDegreeC: nil))
        
    }
    
    private func createWeatherSummary(currentWeather: CurrentWeather, locationWeather: LocationWeather, forecastDayDetail: ForecastDayDetail) -> WeatherSummary{
        
        let location = locationWeather.name
        let mintempC = forecastDayDetail.mintempC
        let mintempF = forecastDayDetail.mintempF
        let maxtempC = forecastDayDetail.maxtempC
        let maxtempF = forecastDayDetail.maxtempF
        let time = currentWeather.lastUpdated
        let currentDegreeC =  currentWeather.tempC
        let currentDegreeF =  currentWeather.tempF
        let condition = currentWeather.condition.text
        
        let weatherSummary = WeatherSummary(location: location, maxTempC: maxtempC, maxTempF: maxtempF, minTempC: mintempC, minTempF: mintempF, time: time, condition: condition, currentDegreeF: currentDegreeF, currentDegreeC: currentDegreeC)
        return weatherSummary
    }
    
    private func createCardViewModelCreators(currentWeather: CurrentWeather, forecastDatas: [Forecast], astro: Astro) -> [CardViewModelCreator]{
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
