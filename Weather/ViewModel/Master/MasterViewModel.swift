//
//  MasterViewModel.swift
//  Weather
//
//  Created by Long Tran on 03/11/2023.
//

import UIKit
import Combine
import CoreLocation


class MasterViewModel: SearchViewModelDelegate{
  
    
   
    enum EventMasterView{
        case viewDidLoad(currentCoordinateLocation: String?)
        case back(index: Int)
        
    }
    
    enum FetchDataOutput{
        case fetchSuccessContentViewModels(contentViewModels: [ContentViewModel])
        case layoutCurrentPageControl( currentPageControl: Int)
        case layoutNumberPageControl(numberPageControl: Int)
        case setContentOffSet(index: Int)
        case appendContentView(contentViewModel: ContentViewModel)
        case removeContentView(index: Int)
        case reorderContentView(sourcePosition: Int, destinationPosition: Int)
    
    }

    let isForeCastCurrentWeather = CurrentValueSubject<Bool, Never>(false)
    let weatherSummaries = CurrentValueSubject<[Int: WeatherSummary], Never>([:])
    private var currentPageControl = 0
    private let contentSize = CGSize(width: SCREEN_WIDTH(), height: SCREEN_HEIGHT())
    private let outputFetchData = PassthroughSubject<FetchDataOutput, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var imgContentViews: [UIImage] = []
    var contentViewModels = [ContentViewModel]()

    
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
                self?.isForeCastCurrentWeather.value = (currentCoordinateLocation != nil) ? true: false
            case .back(index: let index):
                self!.currentPageControl = index
                self?.outputFetchData.send(.layoutCurrentPageControl(currentPageControl: self!.currentPageControl))
                self?.outputFetchData.send(.setContentOffSet(index: self!.currentPageControl))
            }
            }.store(in: &cancellables)
        
        return outputFetchData.eraseToAnyPublisher()
    }
    
    private func getWeatherLocations(currentCoor: String?){
        let locations = CoreDataHelper.shared.getNameLocationsCoreData()
        contentViewModels  = []
        
        if let currentCoor = currentCoor{
            let coor = Coordinate(lat: Double(currentCoor.split(separator: ",")[0])!, lon: Double(currentCoor.split(separator: ",")[1])!)
            let contentViewModel = ContentViewModel(nameLocation: "", coordinate: coor)
            setupWeatherSummary(index: 0, contentViewModel: contentViewModel)
            contentViewModels.append(contentViewModel)
        }
        
        for index in 0..<locations.count{
            let contentViewModel = ContentViewModel(nameLocation: locations[index], coordinate: nil)
            contentViewModels.append(contentViewModel)
            if currentCoor != nil{
                setupWeatherSummary(index: index + 1, contentViewModel: contentViewModel)
            }else{
                setupWeatherSummary(index: index, contentViewModel: contentViewModel)
            }
         
        }
       
        outputFetchData.send(.fetchSuccessContentViewModels(contentViewModels: contentViewModels))
        outputFetchData.send(.layoutNumberPageControl(numberPageControl: contentViewModels.count))
        outputFetchData.send(.layoutCurrentPageControl(currentPageControl: 0))
       
    }
    
    private func setupWeatherSummary(index: Int, contentViewModel: ContentViewModel){
        contentViewModel.weatherSummary.sink {[weak self] weatherSummary in
            self?.weatherSummaries.value[index] = weatherSummary
        }.store(in: &cancellables)
    }
    
    private func createImgContentView(contentView: ContentView) -> UIImage{
        let img = contentView.ts_toImage()
        return img
        
    }
    
    func removeContentView(at index: Int) {
        weatherSummaries.value.removeValue(forKey: index)
//        var weatherSumaryNew = weatherSummaries.value
        for key in weatherSummaries.value.keys.sorted(){
            if key > index{
                if let value = weatherSummaries.value.removeValue(forKey: key) {
                    weatherSummaries.value[key - 1] = value
                }
               
            }
        }
        contentViewModels.remove(at: index)
        outputFetchData.send(.layoutNumberPageControl(numberPageControl: contentViewModels.count))
        outputFetchData.send(.removeContentView(index: index))
    }
    
    func reorderContentView(sourcePosition: Int, destinationPostion: Int) {

        if sourcePosition < destinationPostion{
            let range = stride(from: sourcePosition, to: destinationPostion, by: 1)
            for i in range{
                if let value1 = weatherSummaries.value[Int(i)], let value2 = weatherSummaries.value[Int(i+1)] {
                    weatherSummaries.value[Int(i)] = value2
                    weatherSummaries.value[Int(i+1)] = value1
                }
                outputFetchData.send(.reorderContentView(sourcePosition: i, destinationPosition: i+1))
            }
        }else{
            let range = stride(from: sourcePosition, to: destinationPostion, by: -1)
            for i in range{
                if let value1 = weatherSummaries.value[Int(i)], let value2 = weatherSummaries.value[Int(i-1)] {
                    weatherSummaries.value[Int(i)] = value2
                    weatherSummaries.value[Int(i-1)] = value1
                }
                outputFetchData.send(.reorderContentView(sourcePosition: i, destinationPosition: i-1))
            }
        }

        let selectedItem = contentViewModels[Int(sourcePosition)]
        contentViewModels.remove(at: Int(sourcePosition))
        contentViewModels.insert(selectedItem, at: Int(destinationPostion))
        
        
        
    }
    
    func appendContentView(contentViewModel: ContentViewModel) {

        self.contentViewModels.append(contentViewModel)
        outputFetchData.send(.layoutNumberPageControl(numberPageControl: contentViewModels.count))
        outputFetchData.send(.appendContentView(contentViewModel: contentViewModel))
        
    }
    
 
    
    func appendWeatherSummary(weatherSummary: WeatherSummary) {
        weatherSummaries.value[weatherSummaries.value.count] = weatherSummary

    }
     
 }


