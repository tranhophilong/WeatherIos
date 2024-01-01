//
//  BottomAppBarViewModel.swift
//  Weather
//
//  Created by Long Tran on 19/12/2023.
//

import Foundation
import Combine

class BottomAppBarViewModel{
    
    let numberPageControl = CurrentValueSubject<Int, Never>(1)
    let currentPageControl = CurrentValueSubject<Int, Never>(1)
    let isIndicatorLocationFirst = CurrentValueSubject<Bool, Never>(false)
    
    
    func changeNumberPageControl(number: Int){
        numberPageControl.value = number
    }
    
    func changeCurrentPageControl(currentPage: Int){
        currentPageControl.value = currentPage
    }
     
}
