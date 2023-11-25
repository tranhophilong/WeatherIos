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
        if heightHeaderContent + offset - 35.VAdapted >= heightHeaderContent/5 && bodyContentOffsetIsZero == true{
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
            } receiveValue: {[weak self] (forecastDays, nameLocation) in
              
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
                        let headerWeatherItem = self!.getHeaderWeatherItem(currentWeather: currentWeather, forecastDayDetail: forecastDayDetail, nameLocation: nameLocation)
                        
//                        hourly forecast
                        let currentHour = self!.getHour(in: currentWeather.lastUpdated)
                        let hourForecastItems = self!.get24NextHourForecastItem(forecastData: forecastDays, currentHour: Int(currentHour) ?? 0)
                            
                        //      ten day forecast
                        let tendayForecast = self!.getTenDayForecastItem(forecastData: forecastDays, currentWeather: currentWeather)
                        
                        self!.fetchDataOutput.send(.fetchSuccessHeaderWeatherItem(headerWeather: headerWeatherItem))
                        self!.fetchDataOutput.send(.fetchSuccessForecastItem(forecastData: forecastItems))
                        self!.fetchDataOutput.send(.fetchSuccesHourlyForecastItem(forecastData: hourForecastItems))
                        self!.fetchDataOutput.send(.fetchSuccessTendayForecastItem(forecastData: tendayForecast))
                        self!.fetchDataOutput.send(.fetchDataFinished)
                        
                    }catch{
                        self!.fetchDataOutput.send(.fetchDataDidFail)
                    }
                }
                
            }.store(in: &cancellabels)

    }
    
   
    
    private func getHeaderWeatherItem(currentWeather: CurrentWeather, forecastDayDetail: ForecastDayDetail, nameLocation: String) -> HeaderWeatherItem{
        let currentDegree = String(Int(currentWeather.tempC))
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
                    let degree = (String(Int(forecastHour.tempC)), String(Int(forecastHour.tempF)))
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
          
            let item = TenDayForecastItem(iconCondition: UIImage(named: icon)!, lowDegree: lowDegree.0, highDegree: highDegree.0, time: time, subCondtion: subDes)
          
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
//            print(minTempTenDay)
//            print(maxTempTenDay)
//            
            if isFirst{
                let tempBarItem = self!.infoTempBar(minTempDay: round(mintempC), maxTempDay: round(maxtempC), minTempTenDay: round(minTempTenDay), maxTempTenDay: round(maxTempTenDay), currentTemp: round(currentTemp), isShowCurrentTemp: true)
                tempBarItems.append(tempBarItem)
                isFirst = false
            }else{
                let tempBarItem = self!.infoTempBar(minTempDay: round(mintempC), maxTempDay: round(maxtempC), minTempTenDay: round(minTempTenDay), maxTempTenDay: round(maxTempTenDay), currentTemp: round(currentTemp), isShowCurrentTemp: false)
                tempBarItems.append(tempBarItem)
            }
            
            
        }
        
        return (tenDayForecastItems, tempBarItems)
    }
    
    
//   MARK: - Helper func
    
    private func infoUVBar(uvIndex: Int) -> TempBarItem{
        let gradientColors: [UIColor] = [UIColor.green5, UIColor.green4, UIColor.green3, UIColor.yellow3, UIColor.yellow4, UIColor.yellow5, UIColor.orange4, UIColor.orange5, UIColor.red3, UIColor.red4, UIColor.red5, UIColor.purple]
        
        let gradientLocations = (0..<gradientColors.count).map {  NSNumber(value: Float($0) / Float(gradientColors.count - 1)) }
        let startPerUVBar = 0
        let widthPerUVBar = 1
        
        let xPerPointCurrentUV =  CGFloat(uvIndex) / CGFloat(gradientColors.count - 1)
        
        let uvBar = TempBarItem(isShowCurrentTemp: true, startPer: CGFloat(startPerUVBar), widthPer: CGFloat(widthPerUVBar), startPerPoint: CGFloat(xPerPointCurrentUV), gradientColors: gradientColors, gradientLocations: gradientLocations)
        return uvBar
    }
    
    private func infoTempBar(minTempDay: Double, maxTempDay: Double, minTempTenDay: Double, maxTempTenDay: Double, currentTemp: Double, isShowCurrentTemp: Bool) -> TempBarItem{
       var gradientColors: [UIColor] = []
       
        let rangeTenDayTemp =  maxTempTenDay - minTempTenDay
        
        for temp in Int(minTempDay)...Int(maxTempDay){
            let colorTemp = converTempToColor(temp: CGFloat(temp))
            gradientColors.append(colorTemp)
        }
        
        gradientColors = gradientColors.reduce(into: [], { result, element in
            if !result.contains(element){
                result.append(element)
            }
        })
        
        gradientColors.append(gradientColors.last!)
        let gradientLocations = (0..<gradientColors.count).map {  NSNumber(value: Float($0) / Float(gradientColors.count - 1)) }


        let startPerTempBar = 1 - ((maxTempTenDay - minTempDay) / rangeTenDayTemp)
       let widthPerTempBar = (maxTempDay - minTempDay) / rangeTenDayTemp
       let xPerPointCurrentTemp = 1 - ((maxTempTenDay - currentTemp) / rangeTenDayTemp)
        
        let tempBarItem = TempBarItem(isShowCurrentTemp: isShowCurrentTemp, startPer: CGFloat(startPerTempBar), widthPer: CGFloat(widthPerTempBar), startPerPoint: CGFloat(xPerPointCurrentTemp), gradientColors: gradientColors, gradientLocations: gradientLocations)
        return tempBarItem
    }
    
    private func converTempToColor(temp: CGFloat) -> UIColor{
        if temp < -15{
            return .darkBlue1
        }
        else if temp < -10{
            return .darkBlue2
        }else if temp < -5{
            return .darkBlue3
        }
        else if temp < 0{
            return .lightBlue4
        }else if temp < 15{
            return .lightBlue3
        }
        else if  temp < 16{
            return .green1
        }else if temp < 17{
            return .green2
        }else if temp < 18{
            return .green3
        }else if temp < 19{
            return .green4
        }else if temp < 20{
            return .green5
        }
        else if  temp < 21{
            return .yellow1
        }else if temp < 22{
            return .yellow2
        }else if temp < 23{
            return .yellow3
        }else if temp < 24{
            return .yellow4
        }else if temp < 25{
            return .yellow5
        }else if temp < 26{
            return .orange1
        }else if temp < 27{
            return .orange2
        }else if temp < 28{
            return .orange3
        }else if temp < 29{
            return .orange4
        }
        else if  temp < 30{
            return .orange5
        }else if temp < 31{
            return .red4
        }else {
            return .red5
        }
    }
    
    private func getLevelUV(of index: Int) -> String{
        var level = ""
        if index >= 0 && index < 3{
            level = "Low"
        }else if index < 6{
            level = "Moderate"
        }else if index < 8{
            level = "High"
        }else if index < 11{
            level = "Very high"
        }else{
            level = "Extreme violet"
        }
        
        return level
    }
    
    private func getWeekDay(of string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: string) // Replace with your desired date
        if let unwrappedDate = date {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.weekday], from: unwrappedDate)
            if let weekday = components.weekday {
                if weekday == 2{
                    return "Mon"
                }else if weekday == 3{
                    return "Tue"
                }else if weekday == 4{
                    return "Wed"
                }else if weekday == 5{
                    return "Thu"
                }else if weekday == 6{
                    return "Fri"
                }else if  weekday == 7{
                    return "Sat"
                }else {
                    return "Sun"
                }
            }
        } else {
            return "Today"
        }
        return ""
    }
    
    private  func getNameIcon(of urlIcon: String, isday: Bool) -> String{
      let pattern = #"(\d+)\.png"#
      let nameIcon = matches(for: pattern, in: urlIcon)
        return isday ? nameIcon.replacingOccurrences(of: ".png", with: "") : nameIcon.replacingOccurrences(of: ".png", with: "N")
    }
    
  private func matches(for regex: String, in text: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }[0]
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return ""
        }
    }

    
   private func getDay(in localTime: String) -> String{
       let startIndex = localTime.index(localTime.startIndex, offsetBy: 8)
       let endIndex = localTime.index(localTime.startIndex, offsetBy: 9)
       
       return String(localTime[startIndex...endIndex])
   }
   
   private func getHour(in localTime: String) -> String{
       let startIndex = localTime.index(localTime.startIndex, offsetBy: 11)
       let endIndex = localTime.index(localTime.startIndex, offsetBy: 12)
       
       return String(localTime[startIndex...endIndex])
   }
   
    private func getIndexAstro(in time: String) -> Int{
        
       let time24 = timeConversion24(time12: time)
        
        let startIndex = time24.index(time24.startIndex, offsetBy: 0)
        let endIndex = time24.index(time24.startIndex, offsetBy: 1)
        
        return Int(String(time24[startIndex...endIndex])) ?? 0
    }
    
   private func timeConversion24(time12: String) -> String {
        let dateAsString = time12
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"

        let date = df.date(from: dateAsString)
        df.dateFormat = "HH:mm"

        let time24 = df.string(from: date!)
        return time24
    }
}
