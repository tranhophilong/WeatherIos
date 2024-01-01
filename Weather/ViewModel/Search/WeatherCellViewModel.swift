//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Long Tran on 15/12/2023.
//

import UIKit
import Combine

struct WeatherCellViewModel{
    let location = CurrentValueSubject<String, Never>("")
    let time = PassthroughSubject<String, Never>()
    let condtion = PassthroughSubject<String, Never>()
    let highLowDegree = PassthroughSubject<String, Never>()
    let currentDegree = PassthroughSubject<String, Never>()
    let backgroundName = PassthroughSubject<String, Never>()
    let isClearBackground = PassthroughSubject<Bool, Never>()
    let isHiddenConditionLbl = CurrentValueSubject<Bool, Never>(false)
    let isHighLowLbl = CurrentValueSubject<Bool, Never>(false)
    
    init(location: String, time: String, condition: String, lowDegree: String, highDegree: String, currentDegree: String, backgroundName: String, isClearBackground: Bool){
        self.location.value = location
        self.time.send(time)
        self.condtion.send(condition)
        self.highLowDegree.send("H:\(highDegree)° L:\(lowDegree)°")
        self.currentDegree.send("\(currentDegree)°")
        self.backgroundName.send(backgroundName)
        self.isClearBackground.send(isClearBackground)
    }
    
    func hiddenConditionHighLowLbl(is isHidden: Bool){
        isHiddenConditionLbl.value = isHidden
        isHighLowLbl.value = isHidden
    }
    
}



