//
//  TenDayForecastViewModel.swift
//  Weather
//
//  Created by Long Tran on 15/12/2023.
//

import UIKit
import Combine


struct TenDayForecastCellViewModel{
    let iconCondition: UIImage
    let lowDegree: String
    let highDegree: String
    let time: String
    let subCondtion: String
}


class TenDayForecastViewModel: ContentCardViewModel{
   
   private let forecastDatas: [Forecast]
   private let currentWeather: CurrentWeather
   private var tenDayForecastCellViewModels = [TenDayForecastCellViewModel]()
   private var tempBarViewModels = [GradientColorViewModel]()
   let cellViewModels = PassthroughSubject<([TenDayForecastCellViewModel], [GradientColorViewModel]), Never>()
    
    init(forecastDatas: [Forecast], currentWeather: CurrentWeather){
        self.forecastDatas = forecastDatas
        self.currentWeather = currentWeather
    }
      
    func createCellViewModels(){
       var isFirst = true
       var minTempTenDay = forecastDatas[0].forecastday[0].day.mintempC
       var maxTempTenDay = forecastDatas[0].forecastday[0].day.maxtempC

       forecastDatas.forEach {[weak self] forecast in
           let forecastDay = forecast.forecastday[0].day
           let urlIcon = forecastDay.condition.icon
           let icon = urlIcon.lowercased().contains("day") ? ImageHandler.getNameIcon(of: urlIcon, isday: true) : ImageHandler.getNameIcon(of: urlIcon, isday: false)
           let lowDegree = (String(Int(round(forecastDay.mintempC))), String(Int(round(forecastDay.mintempF))))
           let highDegree = (String(Int(round(forecastDay.maxtempC))), String(Int(round(forecastDay.maxtempF))))
           var time = forecast.forecastday[0].date
           if isFirst{
               time = "Today"
               isFirst = false
           }
           time = TimeHandler.getWeekDay(of: time)
           let dailyChanceOfRain = forecastDay.dailyChanceOfRain
           var subDes = ""
           if dailyChanceOfRain != 0{
               subDes = String(dailyChanceOfRain) + "%"
           }

           let item = TenDayForecastCellViewModel(iconCondition: (UIImage(named: icon) ?? UIImage(systemName: "square.and.arrow.up"))!, lowDegree: lowDegree.0, highDegree: highDegree.0, time: time, subCondtion: subDes)

           minTempTenDay = min(minTempTenDay, Double(item.lowDegree)!)
           maxTempTenDay = max(maxTempTenDay, Double(item.highDegree)!)

           self!.tenDayForecastCellViewModels.append(item)
       }

       isFirst = true
       forecastDatas.forEach {[weak self] forecast in
           let forecastDay = forecast.forecastday[0].day
           let currentTemp = self!.currentWeather.tempC
           let mintempC = forecastDay.mintempC
           let maxtempC = forecastDay.maxtempC
           let infotempBar = self!.infoTempBar(minTempDay: round(mintempC), maxTempDay: round(maxtempC), minTempTenDay: round(minTempTenDay), maxTempTenDay: round(maxTempTenDay), currentTemp: round(currentTemp), isShowCurrentTemp: false)
           self!.tempBarViewModels.append(infotempBar)
       }
    
    cellViewModels.send((tenDayForecastCellViewModels, tempBarViewModels))

       }
    
    
    private func infoTempBar(minTempDay: Double, maxTempDay: Double, minTempTenDay: Double, maxTempTenDay: Double, currentTemp: Double, isShowCurrentTemp: Bool) -> GradientColorViewModel{
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
       let tempBarItem = GradientColorViewModel(isShowCurrentIndex: isShowCurrentTemp, startPerGradientColors: CGFloat(startPerTempBar), widthPerGradientColors: CGFloat(widthPerTempBar), startPerIndex: CGFloat(xPerPointCurrentTemp), gradientColors: gradientColors, gradientLocations: gradientLocations)
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
           return .green5
       }else if temp < 17{
           return .green4
       }else if temp < 18{
           return .green3
       }else if temp < 19{
           return .green2
       }else if temp < 20{
           return .green1
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

}
