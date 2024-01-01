//
//  HeaderContentViewModel.swift
//  Weather
//
//  Created by Long Tran on 03/11/2023.
//

import UIKit
import Combine

class HeaderContentViewModel{
    
    
    let alphaColorDegreeLbl = CurrentValueSubject<CGFloat, Never>(1)
    let alphaColorhightLowDegreeLbl = CurrentValueSubject<CGFloat, Never>(1)
    let alphaColorConditionWeatherLbl = CurrentValueSubject<CGFloat, Never>(1)
    let alphaColorDegreeConditionLbl = CurrentValueSubject<CGFloat, Never>(0)
    let disLocationLblAndTopHeader = CurrentValueSubject<CGFloat, Never>(0)
    
    let nameLocation = CurrentValueSubject<String, Never>("--")
    let currentDegree = CurrentValueSubject<String, Never>("")
    let highLowDegree = CurrentValueSubject<String, Never>("")
    let condition = CurrentValueSubject<String, Never>("")
    let conditionDegree = CurrentValueSubject<String, Never>("")
    let isHiddenDegreeIcon = CurrentValueSubject<Bool, Never>(true)
    
    
    func sendData(forecastDayDetail: ForecastDayDetail, currentWeather: CurrentWeather, locationWeather: LocationWeather){
        
        let nameLocation = locationWeather.name
        let currentDegree = String(Int(round(currentWeather.tempC)))
        let highestDegree = String(Int(round(forecastDayDetail.maxtempC)))
        let lowestDegree = String(Int(round(forecastDayDetail.mintempC)))
        let condition = currentWeather.condition.text
        
        self.nameLocation.value = nameLocation
        self.currentDegree.value = currentDegree
        self.highLowDegree.value = "H:\(highestDegree)° L:\(lowestDegree)°"
        self.condition.value = condition
        self.conditionDegree.value = "\(currentDegree)° | \(condition)"
        self.isHiddenDegreeIcon.value = false
    }
    
    func changeColorLbl(with contentOffset: CGFloat, disHighLowDegreeLblAndBottomHeader: CGFloat, disConditionWeatherLblAndBottomHeader: CGFloat, disDegreeLblAndBottomHeader: CGFloat, disDegreeConditionAndBottomHeader: CGFloat, heightDegreeLbl: CGFloat, heightHighAndLowDegreeLbl: CGFloat, heightConditionLbl: CGFloat){
    
  
        let alpha1 =   ( disHighLowDegreeLblAndBottomHeader  + heightHighAndLowDegreeLbl + contentOffset ) / (disHighLowDegreeLblAndBottomHeader / 2)
        alphaColorhightLowDegreeLbl.value = alpha1
        
        let alpha2 = (disConditionWeatherLblAndBottomHeader + heightConditionLbl  + heightHighAndLowDegreeLbl + contentOffset) / (disConditionWeatherLblAndBottomHeader - disHighLowDegreeLblAndBottomHeader  )
        alphaColorConditionWeatherLbl.value = alpha2
        
        let alpha3 = (disDegreeLblAndBottomHeader  + (heightDegreeLbl / 2) + heightConditionLbl + contentOffset) / (disDegreeLblAndBottomHeader - disConditionWeatherLblAndBottomHeader - heightConditionLbl )
        
        alphaColorDegreeLbl.value = alpha3
        
        let alpha4 = (disDegreeConditionAndBottomHeader + contentOffset) / (heightDegreeLbl / 2 - heightConditionLbl)
        
//  DegreeConditionLbl will show
        alphaColorDegreeConditionLbl.value = 1 - alpha4
        
      
    }
    
    func changeDisLblAndTopHeaderDidScroll(with contentOffset: CGFloat, heightHeaderStart: CGFloat, heightHightAndLowDegreeLbl: CGFloat){
        let offset = contentOffset * 1/3 + heightHightAndLowDegreeLbl / 2
        disLocationLblAndTopHeader.value = heightHeaderStart + offset
    }
    
}
