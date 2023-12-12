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
     
    enum EventInput{
        case initViewWithCoor(coor: Coordinate)
        case initViewWithNameLocation(nameLocation: String)
        
    }
    
    enum FetchDataOutput{
        case fetchDataDidFail
        case fetchDataFinished
        case fetchSuccesHourlyForecastItem(forecastData: [HourlyForecastItem])
        case fetchSuccessTendayForecastItem(forecastData: ([TenDayForecastItem], [TempBarItem]))
        case fetchSuccessForecastItem(forecastData: [ForecastItem])
        case fetchSuccessHeaderWeatherItem(headerWeather: HeaderWeatherItem)
        case fetchSuccessUVBar(uvBarItem: TempBarItem)
        case fetchSuccessWeatherItem(weatherItem: WeatherItem)
      
    }
    
    let heightHeader = CurrentValueSubject<CGFloat, Never>(heightHeaderContent)
    private var didGetContentOffSetDidScroll: Bool = false
    private var contentOffSetDidScroll: CGFloat = 0
    let bodyContentState = PassthroughSubject<(BodyContentState, CGFloat), Never>()
    let changeLblHeader = PassthroughSubject<(Bool, CGFloat), Never>()
    var cancellabels = Set<AnyCancellable>()
    let fetchDataOutput =  PassthroughSubject<FetchDataOutput, Never>()
    
    func transform(input: AnyPublisher<EventInput, Never>) -> AnyPublisher<FetchDataOutput, Never>{
        input.sink { [weak self] event in
            switch event{
          
            case .initViewWithCoor(coor: let coor):
                self!.getDataWeatherLocation(coor: coor, nameLocation: "")
            case .initViewWithNameLocation(nameLocation: let nameLocation):
                self!.getDataWeatherLocation(coor: nil, nameLocation: nameLocation)
            }
        }.store(in: &cancellabels)
        return fetchDataOutput.eraseToAnyPublisher()
    }
  
    
//    MARK: - Scroll Action
    func scrollAction(with contentOffset: CGFloat, bodyContentOffsetIsZero: Bool){
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
//                        current forecast
                        if let  coor = coor{
                            urlCurrentWeather  = urlCurrentWeather + "&q=\(coor.lat),\(coor.lon)"
                        }else{
                            urlCurrentWeather = urlCurrentWeather +  "&q=\(nameLocation)"
                        }
                        
                        let currentWeather = try await WeatherService.shared.fetchCurrentWeather(with: urlCurrentWeather).async()
                        let astro = forecastDays[0].forecastday[0].astro
                        let forecastItems =  self!.getForecastItem(currentWeather: currentWeather, astroForecast: astro)
                        
//                        Header weather
                        let forecastDayDetail = forecastDays[0].forecastday[0].day
                        let headerWeatherItem = self!.getHeaderWeatherItem(currentWeather: currentWeather, forecastDayDetail: forecastDayDetail, nameLocation: locationWeather.name)
                        
//                        hourly forecast
                        let currentHour = self!.getHour(in: currentWeather.lastUpdated)
                        let hourForecastItems = self!.get24NextHourForecastItem(forecastData: forecastDays, currentHour: Int(currentHour) ?? 0)
                            
                        //      ten day forecast
                        let tendayForecastItem = self!.getTenDayForecastItem(forecastData: forecastDays, currentWeather: currentWeather)
                        
//                        weatherItem
                        let weatherItem = self!.getWeatherItem(locationWeather: locationWeather, forecastDayDetail: forecastDayDetail, currentWeather: currentWeather)
                        
                        self?.fetchDataOutput.send(.fetchSuccessWeatherItem(weatherItem: weatherItem))
                        self!.fetchDataOutput.send(.fetchSuccessHeaderWeatherItem(headerWeather: headerWeatherItem))
                        self!.fetchDataOutput.send(.fetchSuccessForecastItem(forecastData: forecastItems))
                        self!.fetchDataOutput.send(.fetchSuccesHourlyForecastItem(forecastData: hourForecastItems))
                        self!.fetchDataOutput.send(.fetchSuccessTendayForecastItem(forecastData: tendayForecastItem))
                        self!.fetchDataOutput.send(.fetchDataFinished)
                        
                    }catch{
                        self!.fetchDataOutput.send(.fetchDataDidFail)
                    }
                }
                
            }.store(in: &cancellabels)

    }
    
   
    
    private func getHeaderWeatherItem(currentWeather: CurrentWeather, forecastDayDetail: ForecastDayDetail, nameLocation: String) -> HeaderWeatherItem{
        let currentDegree = String(Int(round(currentWeather.tempC)))
        let condition = currentWeather.condition.text
        let highDegree = String(Int(forecastDayDetail.maxtempC))
        let lowDegree = String(Int(forecastDayDetail.mintempC))
                
        return HeaderWeatherItem(nameLocation: nameLocation, degree: currentDegree, conditon: condition, lowDegree: lowDegree, highDegree: highDegree)
    }
    
    private func getForecastItem(currentWeather: CurrentWeather, astroForecast: Astro) ->[ForecastItem]{
        var forecastItems: [ForecastItem] = []
        
//        uv Forecast
        let uvIndex = Int(currentWeather.uv)
        let levelUv = getLevelUV(of: uvIndex)
        let uvForecastItem = ForecastItem(title: "UV", icon: UIImage(systemName: "sun.max.fill")!, index: String(uvIndex), description: levelUv, subdescription: "", typeForecast: .uv)
        let infoUVBar = infoUVBar(uvIndex: uvIndex)
        self.fetchDataOutput.send(.fetchSuccessUVBar(uvBarItem: infoUVBar))
        forecastItems.append(uvForecastItem)
        
//      astro
        let sunrise = timeConversion24(time12: astroForecast.sunrise)
        let sunset = timeConversion24(time12: astroForecast.sunset)
        var astroForecastItem = ForecastItem(title: "", icon: UIImage(systemName: "sun.max")!, index: "", description: "", subdescription: "", typeForecast: .astro)
        if currentWeather.isDay == 1{
            astroForecastItem = ForecastItem(title: "SUNSET",icon: UIImage(systemName: "sunset.fill")!, index: sunset, description: "", subdescription: "Sunrise: \(sunrise)", typeForecast: .astro)
        }else{
            astroForecastItem = ForecastItem(title: "SUNRISE", icon: UIImage(systemName: "sunrise.fill")!, index: sunrise, description: "", subdescription: "Sunset: \(sunset)", typeForecast: .astro)
        }
        forecastItems.append(astroForecastItem)
        
//      Wind
        let wind = Int(currentWeather.windKph)
        let windForecastItem = ForecastItem(title:"WIND", icon: UIImage(systemName: "wind")!, index: String(wind) + "km/h", description: "", subdescription: "", typeForecast: .wind)
        forecastItems.append(windForecastItem)
        
//    precip
        let precip =  Int(currentWeather.precipMn)
        let precipForecastItem  = ForecastItem(title: "PRECIPIPTATION", icon: UIImage(systemName: "drop.fill")!, index: String(precip) + "mm", description: "In last 24h", subdescription: "", typeForecast: .precip)
        forecastItems.append(precipForecastItem)
    
//        feelsLike
        let feelsLike = Int(currentWeather.feelslikeC)
        let feelsLikeForecastItem = ForecastItem(title: "FEELSLIKE", icon: UIImage(systemName: "thermometer.medium")!, index: String(feelsLike) + "°", description: "", subdescription: "", typeForecast: .feelslike)
        forecastItems.append(feelsLikeForecastItem)
        
//        Humidity
        let humidity = Int(currentWeather.humidity)
        let humidityForecastItem = ForecastItem(title: "HUMIDITY", icon: UIImage(systemName: "humidity")!, index: String(humidity) + "%", description: "", subdescription: "", typeForecast: .humidity)
        forecastItems.append(humidityForecastItem)
        
//        visibiLity
        let visKM = Int(currentWeather.visKM)
        let visForecastItem = ForecastItem(title: "VISIBILITY", icon: UIImage(systemName: "eye.fill")!, index: "\(visKM) Km", description: "", subdescription: "", typeForecast: .visibility)
        forecastItems.append(visForecastItem)
        
//        presure
        let pressureMB = currentWeather.pressureMB
        let pressureforecastItem = ForecastItem(title: "PRESSURE", icon: UIImage(systemName: "gauge.medium")! ,index: String(pressureMB) + "Mb", description: "", subdescription: "", typeForecast: .pressure)
        forecastItems.append(pressureforecastItem)
        
        return forecastItems
    }
    
    

    private func get24NextHourForecastItem(forecastData: [Forecast], currentHour: Int) -> [HourlyForecastItem]{
        
        var hourlyForecasts: [HourlyForecastItem] = []
//      index == 0 -> time is "Now"
        var isFirst = true
        var isAddData = false
        
        for forecast in forecastData{
            let forecastDay = forecast.forecastday[0]
            let sunRiseTime =  timeConversion24(time12: forecastDay.astro.sunrise)
            let sunSetTime = timeConversion24(time12: forecastDay.astro.sunset)
            
            let indexSunrise = getIndexAstro(in: forecastDay.astro.sunrise)
            let indexSunset = getIndexAstro(in: forecastDay.astro.sunset)

            for forecastHour in forecastDay.hour{
                    let hour = getHour(in: forecastHour.time)
                    let urlIcon = forecastHour.condition.icon
                    let degree = (String(Int(round(forecastHour.tempC))), String(Int(round(forecastHour.tempF))))
                    let icon = urlIcon.lowercased().contains("day") ? getNameIcon(of: urlIcon, isday: true) : getNameIcon(of: urlIcon, isday: false)
                    let chanceOffRain = forecastHour.chanceOfRain
                    var subCondition = ""
                    if chanceOffRain == 0{
                        subCondition = ""
                    }else{
                        subCondition = String(chanceOffRain) + "%"
                    }
                    if Int(hour)! >= currentHour{
                        isAddData = true
                    }
                    if isAddData{
                        if isFirst{
                            let forecastItem = HourlyForecastItem(time: "Now", imgCondtion: UIImage(named: icon)!, subCondtion: subCondition, degree: degree.0 + "°")
                            isFirst = false
                            
                            hourlyForecasts.append(forecastItem)
                        }else{
                            let forecastItem = HourlyForecastItem(time: hour, imgCondtion: UIImage(named: icon)!, subCondtion: subCondition, degree: degree.0 + "°")
                            hourlyForecasts.append(forecastItem)
                        }
                        
                        if Int(hour)! == indexSunrise{
                            let sunriseItem = HourlyForecastItem(time: sunRiseTime, imgCondtion: UIImage(named: "sunrise")!, subCondtion: "", degree: "Sunrise")
                            hourlyForecasts.append(sunriseItem)
                        }
                        
                        if Int(hour)! == indexSunset{
                            let sunsetItem = HourlyForecastItem(time: sunSetTime, imgCondtion: UIImage(named: "sunset")!, subCondtion: "", degree: "Sunset")
                            hourlyForecasts.append(sunsetItem)
                        }
                        
                       
                    }
                if hourlyForecasts.count >= 26{
                    return hourlyForecasts
                }
            }
        }
        
        return hourlyForecasts
    }
    
    private func getTenDayForecastItem(forecastData: [Forecast], currentWeather: CurrentWeather) -> ([TenDayForecastItem], [TempBarItem]){
        var tenDayForecastItems: [TenDayForecastItem] = []
        var tempBarItems: [TempBarItem] = []
        var isFirst = true
        
        
        var minTempTenDay = forecastData[0].forecastday[0].day.mintempC
        var maxTempTenDay = forecastData[0].forecastday[0].day.maxtempC
        
        forecastData.forEach {[weak self] forecast in
            let forecastDay = forecast.forecastday[0].day
            let urlIcon = forecastDay.condition.icon
            let icon = urlIcon.lowercased().contains("day") ? self!.getNameIcon(of: urlIcon, isday: true) : self!.getNameIcon(of: urlIcon, isday: false)
            let lowDegree = (String(Int(round(forecastDay.mintempC))), String(Int(round(forecastDay.mintempF))))
            let highDegree = (String(Int(round(forecastDay.maxtempC))), String(Int(round(forecastDay.maxtempF))))
            var time = forecast.forecastday[0].date
            if isFirst{
                time = "Today"
                isFirst = false
            }
            time = self!.getWeekDay(of: time)
            let dailyChanceOfRain = forecastDay.dailyChanceOfRain
            var subDes = ""
            if dailyChanceOfRain != 0{
                subDes = String(dailyChanceOfRain) + "%"
            }

            let item = TenDayForecastItem(iconCondition: (UIImage(named: icon) ?? UIImage(systemName: "square.and.arrow.up"))!, lowDegree: lowDegree.0, highDegree: highDegree.0, time: time, subCondtion: subDes)
          
            minTempTenDay = min(minTempTenDay, Double(item.lowDegree)!)
            maxTempTenDay = max(maxTempTenDay, Double(item.highDegree)!)
            
            tenDayForecastItems.append(item)
        }
        
        isFirst = true
        forecastData.forEach {[weak self] forecast in
            
            let forecastDay = forecast.forecastday[0].day
            let currentTemp = currentWeather.tempC
            let mintempC = forecastDay.mintempC
            let maxtempC = forecastDay.maxtempC

//            if isFirst{
//                let tempBarItem = self!.infoTempBar(minTempDay: round(mintempC), maxTempDay: round(maxtempC), minTempTenDay: round(minTempTenDay), maxTempTenDay: round(maxTempTenDay), currentTemp: round(currentTemp), isShowCurrentTemp: f)
//                tempBarItems.append(tempBarItem)
//                isFirst = false
//            }else{
//                let tempBarItem = self!.infoTempBar(minTempDay: round(mintempC), maxTempDay: round(maxtempC), minTempTenDay: round(minTempTenDay), maxTempTenDay: round(maxTempTenDay), currentTemp: round(currentTemp), isShowCurrentTemp: false)
//                tempBarItems.append(tempBarItem)
//            }
            
            let tempBarItem = self!.infoTempBar(minTempDay: round(mintempC), maxTempDay: round(maxtempC), minTempTenDay: round(minTempTenDay), maxTempTenDay: round(maxTempTenDay), currentTemp: round(currentTemp), isShowCurrentTemp: false)
                            tempBarItems.append(tempBarItem)
           
        }
        
        return (tenDayForecastItems, tempBarItems)
    
    }
    
    
    private func getWeatherItem(locationWeather: LocationWeather, forecastDayDetail: ForecastDayDetail, currentWeather: CurrentWeather) -> WeatherItem{
        let weatherItem = WeatherItem(location: locationWeather.name, time: getTime(in: locationWeather.localtime), condtion: currentWeather.condition.text, lowDegree: String(Int(round(forecastDayDetail.mintempC))), highDegree: String(Int(round(forecastDayDetail.maxtempC))), currentDegree: String(Int(round(currentWeather.tempC))) + "°", background: UIImage(named: "sky3.jpeg")!)
        
        return weatherItem
    }
    
    
    

}
