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
    let disLocationLblAndTopHeader = CurrentValueSubject<CGFloat, Never>(heightHeaderContent/5)
    

    func changeColorLbl(with contentOffset: CGFloat){
    
  
        let alpha1 =   ( disHightLowDegreeLblAndBottomHeader  + heightHightAndLowDegreeLbl + contentOffset ) / (disHightLowDegreeLblAndBottomHeader / 2)
        alphaColorhightLowDegreeLbl.value = alpha1
        
        let alpha2 = (disConditionWeatherLblAndBottomHeader + heightConditionLbl  + heightHightAndLowDegreeLbl + contentOffset) / (disConditionWeatherLblAndBottomHeader - disHightLowDegreeLblAndBottomHeader  )
        alphaColorConditionWeatherLbl.value = alpha2
        
        let alpha3 = (disDegreeLblAndBottomHeader  + (heightDegreeLbl / 2) + heightConditionLbl + contentOffset) / (disDegreeLblAndBottomHeader - disConditionWeatherLblAndBottomHeader - heightConditionLbl )
        
        alphaColorDegreeLbl.value = alpha3
        
        let alpha4 = (disDegreeConditionAndBottomHeader + contentOffset) / (heightDegreeLbl / 2 - heightConditionLbl)
        
//  DegreeConditionLbl will show
        alphaColorDegreeConditionLbl.value = 1 - alpha4
        
      
    }
    
    func changeDisLblAndTopHeaderDidScroll(with contentOffset: CGFloat){
        let offset = contentOffset * 1/3 + heightHightAndLowDegreeLbl / 2
        disLocationLblAndTopHeader.value = disLocationLblAndTopHeaderStart + offset
    }
    
}
