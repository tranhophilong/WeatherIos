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
        case viewDidLoad(currentCoordinateLocation: String?)
    }
    
    enum FetchDataOutput{
        case fetchSuccessContentViewModels(contentViewModels: [ContentViewModel])
        case layoutCurrentPageControl( currentPageControl: Int)
        case layoutNumberPageControl(numberPageControl: Int)
    
    }

    private var currentPageControl = 0
    private var numberSubviews = 0
    private let contentSize = CGSize(width: SCREEN_WIDTH(), height: SCREEN_HEIGHT())
    private let outputFetchData = PassthroughSubject<FetchDataOutput, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var contentSizeContainerView = CGSize(width: 0, height: 0)
    private var imgContentViews: [UIImage] = []
    
//  MARK: - Scroll action
    
    func changePageControl(with contentOffsetX: CGFloat){
        var pageIndex = contentOffsetX  / contentSize.width
        currentPageControl = Int(pageIndex)
        outputFetchData.send(.layoutCurrentPageControl(currentPageControl: currentPageControl))
    }
    
    
//    MARK: -  Data
    
    func transform(input: AnyPublisher<EventMasterView, Never>) -> AnyPublisher<FetchDataOutput, Never>{
        input.sink {  [weak self]  event  in
            switch event{
            case .viewDidLoad(currentCoordinateLocation: let currentCoordinateLocation):
                self!.getWeatherLocations(currentCoor: currentCoordinateLocation)
            }
            }.store(in: &cancellables)
        
        return outputFetchData.eraseToAnyPublisher()
    }
    
    private func getWeatherLocations(currentCoor: String?){
        var locations = CoreDataHelper.shared.getNameLocationsCoreData()
        var contentViewModels = [ContentViewModel]()
        for location in locations{
            let contentViewModel = ContentViewModel(nameLocation: location, coordinate: nil)
            contentViewModels.append(contentViewModel)
        }
        if let currentCoor = currentCoor{
            let coor = Coordinate(lat: Double(currentCoor.split(separator: ",")[0])!, lon: Double(currentCoor.split(separator: ",")[1])!)
            let contentViewModel = ContentViewModel(nameLocation: "", coordinate: coor)
            contentViewModels.append(contentViewModel)
        }
        
        outputFetchData.send(.fetchSuccessContentViewModels(contentViewModels: contentViewModels))
        outputFetchData.send(.layoutNumberPageControl(numberPageControl: contentViewModels.count))
        outputFetchData.send(.layoutCurrentPageControl(currentPageControl: 1))
       
    }
    
    private func createImgContentView(contentView: ContentView) -> UIImage{
        let img = contentView.ts_toImage()
        return img
        
    }
    
    private func addContentView(contentView: ContentView){
        
    }
    
    private func reoderContentView(sourceIndex: Int, desIndex: Int){
        
    }
    
    private func removeContentView(at index: Int){
        
    }
    
    
    
 }


