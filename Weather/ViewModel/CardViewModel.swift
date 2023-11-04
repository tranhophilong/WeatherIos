//
//  CardViewModel.swift
//  Weather
//
//  Created by Long Tran on 03/11/2023.
//

import UIKit
import Combine


class CardViewModel{
    
    
    let remakeConstraintHeader = CurrentValueSubject<Bool, Never>(false)
    private let initAlphaColorBackground: CGFloat = 0.8
    let alphaColorBackgroundHeader = CurrentValueSubject<CGFloat, Never>(0)
    let alphaColorBackgroundCardView = CurrentValueSubject<CGFloat, Never>(0.8)
    let alphaColorTitleAndIcon = CurrentValueSubject<CGFloat, Never>(0.8)
    
    
//    MARK: - Scroll action
    private func checkScrollToHeader(with contentOffSet: CGFloat, heightHeader: CGFloat, maxY: CGFloat) -> Bool {

        if maxY - CGFloat(heightHeader) <= contentOffSet{
            return  true
        }else{
            return  false
        }
    }
    
    func changeAlphaColorTopHeader(with contentOffset: CGFloat, maxYCardView: CGFloat, heightHeaderCardView: CGFloat){
        
        if checkScrollToHeader(with: contentOffset, heightHeader: heightHeaderCardView, maxY: maxYCardView){
            let alpha = (contentOffset - maxYCardView) / heightHeaderCardView * -1
            alphaColorBackgroundHeader.value = initAlphaColorBackground - (1 - alpha)
            alphaColorTitleAndIcon.value =  alpha
            alphaColorBackgroundCardView.value = 0
        }else{
            refreshAlphaColor()
        }
    }
    
    private func refreshAlphaColor(){
        alphaColorBackgroundHeader.value = 0
        alphaColorBackgroundCardView.value = initAlphaColorBackground
        alphaColorTitleAndIcon.value = 1
        
    }
    
    func pinHeaderToTop(contentOffSet: CGFloat, minYCardView: CGFloat){
        
        if contentOffSet >= minYCardView{
            remakeConstraintHeader.value = true
        }else{
            remakeConstraintHeader.value = false
        }
        
    }
    
   
}
