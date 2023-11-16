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
        case getCurrentLocationDataWeather(lat: CGFloat, lon: CGFloat )
    }
    
    enum FetchDataOutput{
        case fetchDataDidFail
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
            switch event{
            case .getCurrentLocationDataWeather(lat: let lat, lon: let lon):
                self?.getCurrentLocationDataWeather(lat: lat, lon: lon)
            }
            
        }.store(in: &cancellabels)
        
        return outputFetchData.eraseToAnyPublisher()
    }

   private func getCurrentLocationDataWeather(lat: CGFloat, lon: CGFloat){
       
    }

}


