//
//  MasterViewModel.swift
//  Weather
//
//  Created by Long Tran on 03/11/2023.
//

import UIKit
import Combine
import CoreLocation


class MasterViewModel: NSObject{
    
    enum EventMasterView{
       
    }
    
    enum FetchDataOutput{
      
      
    }
    
    let currentPageControl = CurrentValueSubject<Int, Never>(0)
    private var currentXContainer: CGFloat = 0
    var numberSubviews = CurrentValueSubject<Int, Never>(1)
    let contentSize = CGSize(width: SCREEN_WIDTH(), height: SCREEN_HEIGHT())
    let outputFetchData = PassthroughSubject<FetchDataOutput, Never>()
    private var cancellabels = Set<AnyCancellable>()
    
    private var cancellables = Set<AnyCancellable>()
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
    
    func transform(input: AnyPublisher<EventMasterView, Never>) -> AnyPublisher<FetchDataOutput, Never>{
        input.sink {  [weak self]  event  in
        
            
        }.store(in: &cancellabels)
        
        return outputFetchData.eraseToAnyPublisher()
    }
    
    
    
   

}


