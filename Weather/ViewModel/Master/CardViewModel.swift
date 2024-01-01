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
    private let initAlphaColorBackground: CGFloat = 1
    let alphaColorBackgroundHeader = CurrentValueSubject<CGFloat, Never>(0)
    let alphaColorBackgroundCardView = CurrentValueSubject<CGFloat, Never>(1)
    let alphaColorTitleAndIcon = CurrentValueSubject<CGFloat, Never>(1)
    let hiddenBody = CurrentValueSubject<Bool, Never>(false)
    let title = PassthroughSubject<String, Never>()
    let icon = PassthroughSubject<UIImage, Never>()
    let contentCardViewModel = PassthroughSubject<ContentCardViewModel, Never>()
    private let _title: String
    private let _icon: UIImage
    private let _contentCardViewModel: ContentCardViewModel
    
    init(title: String, icon: UIImage, contentCardViewModel: ContentCardViewModel) {
        _title = title
        _icon = icon
        _contentCardViewModel = contentCardViewModel
    }
    
    func getData(){
        self.title.send(_title)
        self.icon.send(_icon)
        self.contentCardViewModel.send(_contentCardViewModel)
    }
    
//    MARK: - Scroll action
    private func checkScrollToHeader(with contentOffSet: CGFloat, heightHeader: CGFloat, maxY: CGFloat) -> Bool {

        if maxY - CGFloat(heightHeader) + 15.VAdapted <= contentOffSet{
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
            hiddenBody.value = true
        }else{
            refreshAlphaColor()
            hiddenBody.value = false
        }
    }
    
    private func refreshAlphaColor(){
        
        alphaColorBackgroundHeader.value = 1
        alphaColorBackgroundCardView.value = initAlphaColorBackground
        alphaColorTitleAndIcon.value = 1
        
    }
    
    func pinHeaderToTop(contentOffSet: CGFloat, minYCardView: CGFloat){
        
        if contentOffSet >= minYCardView + 15.VAdapted{
            remakeConstraintHeader.value = true
        }else{
            remakeConstraintHeader.value = false
        }
        
    }
    

}
