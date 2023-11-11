//
//  MasterViewModel.swift
//  Weather
//
//  Created by Long Tran on 03/11/2023.
//

import UIKit
import Combine

class MasterViewModel{
    
    let currentPageControl = CurrentValueSubject<Int, Never>(0)
    private var currentXContainer: CGFloat = 0
    var numberSubviews = CurrentValueSubject<Int, Never>(1)
    let contentSize = CGSize(width: SCREEN_WIDTH(), height: SCREEN_HEIGHT())
    
    func changePageControl(with contentOffsetX: CGFloat){
        var pageIndex = contentOffsetX  * CGFloat(numberSubviews.value) / contentSize.width
        if currentXContainer >= contentOffsetX{
            pageIndex = ceil( pageIndex - 0.5)
            
        }else{
            pageIndex = pageIndex + 0.5
        }
        currentPageControl.value = Int(pageIndex)
        currentXContainer = contentOffsetX
    }
    
    
//    MARK: -  Data
    func getData(){
        
    }
}
