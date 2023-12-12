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
        case addContentView(contentView: ContentView)
        case removeContentView(index: Int)
        case reoderContentView(souceIndex: Int, desIndex: Int)
        case getImgContentViews
    }
    
    enum FetchDataOutput{
        case fetchSuccsessContentViews(contentViews: [ContentView], isForecastCurrentWeather: Bool)
        case fetchSuccsessWeatherItems(weatherItems: [WeatherItem])
        case layoutContainerView(contentSize: CGSize)
        case layoutCurrentPageControl( currentPageControl: Int)
        case layoutNumberPageControl(numberPageControl: Int)
        case imgContentViews(imgs: [UIImage])
        
    }

    private var currentPageControl = 0
    private var numberSubviews = 0
    private let contentSize = CGSize(width: SCREEN_WIDTH(), height: SCREEN_HEIGHT())
    private let outputFetchData = PassthroughSubject<FetchDataOutput, Never>()
    private var contentViews: [ContentView] = []
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
            case .viewDidLoad(currentCoordinateLocation: let coordinateLocation):
                self!.getWeatherLocations(currentCoor: coordinateLocation)
            case .addContentView(contentView: let contentView):
                self!.addContentView(contentView: contentView)
            case .removeContentView(index: let index):
                self!.removeContentView(at: index)
            case .reoderContentView(souceIndex: let souceIndex, desIndex: let desIndex):
                self!.reoderContentView(sourceIndex: souceIndex, desIndex: desIndex)
            case .getImgContentViews:
                print("get img")
            }
            }.store(in: &cancellables)
        
        return outputFetchData.eraseToAnyPublisher()
    }
    
    private func getWeatherLocations(currentCoor: String?){
        var isForecastCurrentLocation = false
        var locations = CoreDataHelper.shared.getNameLocationsCoreData()
        var weatherItemsDct: [Int: WeatherItem] = [:]
        var weatherItems: [WeatherItem] = []
        
    
        if let coor = currentCoor{
            locations.insert(coor, at: 0)
            isForecastCurrentLocation = true
        }
        
        for i in 0..<locations.count{
            var coor: Coordinate?
            var nameLocation: String
            
            if i == 0 && isForecastCurrentLocation{
                coor = Coordinate(lat: Double(locations[i].split(separator: ",")[0])!, lon: Double(locations[i].split(separator: ",")[1])!)
                nameLocation = "My Location"
            }else{
                coor = nil
                nameLocation = locations[i]
            }
            
            let contenntView = ContentView(frame: CGRectMake(CGFloat(i) * contentSize.width, 0, contentSize.width, contentSize.height), coor: coor, nameLocation: nameLocation)
            
            weatherItemsDct[i] = nil
            
            let weatherItem = WeatherItem(location: nameLocation, time: "", condtion: "", lowDegree: "", highDegree: "", currentDegree: "", background: UIImage(named: "sky3.jpeg")!)
           
            weatherItems.append(weatherItem)
  
            outputFetchData.send(.fetchSuccsessWeatherItems(weatherItems: weatherItems))
            
            contenntView.weatherItem.sink { completion in
                switch completion{
                    
                case .finished:
                    print("finished")
                case .failure(_):
                    print("fail")
                }
            } receiveValue: {[weak self] value in
                weatherItemsDct[i] = value
                
                let sortedKey = weatherItemsDct.keys.sorted()
                
                for key in sortedKey{
                    weatherItems[key].condtion = weatherItemsDct[key]!.condtion
                    weatherItems[key].currentDegree = weatherItemsDct[key]!.currentDegree
                    weatherItems[key].lowDegree = weatherItemsDct[key]!.lowDegree
                    weatherItems[key].highDegree = weatherItemsDct[key]!.highDegree
                   
                    if key == 0{
                        weatherItems[key].time = weatherItemsDct[key]!.location
                    }else{
                        weatherItems[key].time = weatherItemsDct[key]!.time
                    }
                }
                
                self!.outputFetchData.send(.fetchSuccsessWeatherItems(weatherItems: weatherItems))
                
            }.store(in: &cancellables)
            
           
            contentViews.append(contenntView)
        }
        numberSubviews = locations.count
        currentPageControl = 0
        contentSizeContainerView = CGSize(width: CGFloat(numberSubviews) * contentSize.width , height: contentSize.height)
        
        outputFetchData.send(.fetchSuccsessContentViews(contentViews: contentViews, isForecastCurrentWeather: isForecastCurrentLocation))
        outputFetchData.send(.layoutContainerView(contentSize: contentSizeContainerView))
        outputFetchData.send(.layoutNumberPageControl(numberPageControl: numberSubviews))
        outputFetchData.send(.layoutCurrentPageControl(currentPageControl: currentPageControl))
    }
    
    private func createImgContentView(contentView: ContentView) -> UIImage{
        let img = contentView.ts_toImage()
        return img
    }
    
    private func addContentView(contentView: ContentView){
        contentViews.append(contentView)
        
    }
    
    private func reoderContentView(sourceIndex: Int, desIndex: Int){
        
    }
    
    private func removeContentView(at index: Int){
        
    }
    
    
    
 }


