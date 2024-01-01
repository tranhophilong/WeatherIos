//
//  BodyContentViewModel.swift
//  Weather
//
//  Created by Long Tran on 03/11/2023.
//

import UIKit
import Combine


class BodyContentViewModel{
    
    let cardViewWillDisplay = PassthroughSubject<[(CardViewModel, CGRect)], Never>()
    let contentSizeContainer = CurrentValueSubject<CGSize, Never>(.zero)
    private let spacingItem = CGFloat(10)

   
    func createCardViews(cardViewModelCreators: [CardViewModelCreator]){
        var currentViewOffsetY = CGFloat(0)
        var currentViewOffsetX = CGFloat(0)
        var heightContent = CGFloat(0)
        var widthTemp: CGFloat = 0
        let maxWidthCardView = SCREEN_WIDTH() * 90/100
        var cardViewDisplays: [(CardViewModel, CGRect)] = []
       
        cardViewModelCreators.forEach { cardViewCreator in
            
            var widthCardView: CGFloat = 0
            var heightCardView: CGFloat = 0
            
            switch cardViewCreator{
            case is CardViewTenDayForecastViewModelCreator:
                widthCardView = maxWidthCardView
                heightCardView = 600.VAdapted
                heightContent += heightCardView
            case is CardViewHourlyForecastViewModelCreator:
                widthCardView = maxWidthCardView
                heightCardView = 180.VAdapted
                heightContent += heightCardView
            case is CardViewCurrentForecastViewModelCreator:
                widthCardView = maxWidthCardView/2 - 5.HAdapted
                heightCardView = maxWidthCardView/2 - 5.HAdapted
            
            default:
                break
            }
            let frame = CGRectMake(currentViewOffsetX, currentViewOffsetY, widthCardView, heightCardView)
            cardViewDisplays.append((cardViewCreator.createCardViewModel(), frame))
            currentViewOffsetX += widthCardView + spacingItem
                    
            if currentViewOffsetX + spacingItem >= maxWidthCardView{
                currentViewOffsetY += spacingItem + heightCardView
                currentViewOffsetX = 0
                widthTemp += widthCardView
                if widthTemp > SCREEN_WIDTH() / 2{
                    widthTemp = 0
                    heightContent += heightCardView
                }
            }
            
        }
        
        cardViewWillDisplay.send(cardViewDisplays)
        contentSizeContainer.send(CGSize(width: maxWidthCardView, height: heightContent))
        
        
    }
   
    func checkContentOffsetIsZero(contentOffset: CGFloat) -> Bool{
        if contentOffset <= 0 {
            return true
        }else{
            return false
        }
    }
   
}



