//
//  MainViewModel.swift
//  Weather
//
//  Created by Long Tran on 08/11/2023.
//

import UIKit
import Combine
import CoreData
import CoreLocation

protocol SearchViewModelDelegate:  AnyObject{
    
    func removeContentView(at index: Int)
    func reorderContentView(sourcePosition: Int, destinationPostion: Int)
    func appendContentView(contentViewModel: ContentViewModel)
    func updateWeatherSummarys(weatherSummarys: [Int: WeatherSummary])
}

class SearchViewControllerViewModel{
    
    enum EventInput{
        case viewDidLoad
        case addWeatherCellViewModel(weatherSummary: WeatherSummary)
        case removeLocation(index: Int)
        case reorderLocation(sourcePosition: Int16, destinationPosition: Int16)
        case changeHiddenStateEditView
        case hiddenEditView
        case changeStateEditMode(isEdit: Bool)
        case addContentView(contentViewModel: ContentViewModel)
    }
    
    enum EventOutput{
        case fetchDataFail
        case fetchSuccessWeatherCellViewModels(weatherCellViewModels: [WeatherCellViewModel])
        case isForecastCurrentWeather(isForecast: Bool)
        case isHiddenEditView(isHidden: Bool)
        case isEditMode(isEdit: Bool)
        case isDeactiveSearch(isDeactive: Bool)
        case isForecastCurrentLocationWeather(isForecast: Bool)
    }
    
    private var isForecastCurrentLocationWeather = false
    private var weatherCellViewModels = [WeatherCellViewModel]()
    private var isEditMode = false
    private var isHiddenEditView = true
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var cancellabels = Set<AnyCancellable>()
    let eventOutput = PassthroughSubject<EventOutput, Never>()
    let backToMasterVC = PassthroughSubject<Int, Never>()
    let weatherSummarys  = CurrentValueSubject<[Int: WeatherSummary], Never>([:])
    weak var delegate: SearchViewModelDelegate?
    
    init(isForecastCurrentWeather: Bool){
        self.eventOutput.send(.isHiddenEditView(isHidden: isHiddenEditView))
        self.eventOutput.send(.isEditMode(isEdit: isEditMode))
//        self.weatherSummarys = weatherSummarys
        self.isForecastCurrentLocationWeather = isForecastCurrentWeather
    }
    
    func transform(input: AnyPublisher<EventInput, Never>) -> AnyPublisher<EventOutput, Never>{
        input.sink {  [weak self]  event  in
            switch event{
            case .reorderLocation(sourcePosition: let sourcePosition, destinationPosition: let destinationPosition):
                self!.reorderLocationCoreData(sourcePosition: sourcePosition, destinationPostion: destinationPosition)
                self?.eventOutput.send(.fetchSuccessWeatherCellViewModels(weatherCellViewModels: self!.weatherCellViewModels))
            case .changeHiddenStateEditView:
                self?.isHiddenEditView = !self!.isHiddenEditView
                self?.eventOutput.send(.isHiddenEditView(isHidden: self!.isHiddenEditView))
            case .hiddenEditView:
                self?.isHiddenEditView = true
                self?.eventOutput.send(.isHiddenEditView(isHidden: self!.isHiddenEditView))
            case .changeStateEditMode(isEdit: let isEdit):
                self?.isEditMode = isEdit
                self?.eventOutput.send(.isEditMode(isEdit:  self!.isEditMode))
            case .removeLocation(index: let index):
                self?.removeNameLocationCoreData(at: index)
//                self?.eventOutput.send(.fetchSuccessWeatherCellViewModels(weatherCellViewModels: self!.weatherCellViewModels))
            case .viewDidLoad:
                self?.isEditMode = false
                self?.eventOutput.send(.isEditMode(isEdit: self!.isEditMode))
                self?.setupWeatherCellViewModels()
                self?.eventOutput.send(.isForecastCurrentLocationWeather(isForecast: self!.isForecastCurrentLocationWeather))
            case .addWeatherCellViewModel(weatherSummary: let weatherSummary):
                self?.appendWeatherCellViewModel(weatherSummary: weatherSummary)
            case .addContentView(contentViewModel: let contentViewModel):
                self?.delegate?.appendContentView(contentViewModel: contentViewModel)
            }
            
        }.store(in: &cancellabels)
        
        return eventOutput.eraseToAnyPublisher()
    }
    
    //    MARK: - Data
    
    private func setupWeatherCellViewModels(){
        
        weatherSummarys.sink {[weak self] weatherSummarys in
            let sortedWeatherSummarys = weatherSummarys.sorted{ $0.key < $1.key }.map{ $0.value }
            var weatherCellViewModels = [WeatherCellViewModel]()
            for weatherSummary in sortedWeatherSummarys{
                let weatherCellViewModel = self!.createWeatherCellViewModel(weatherSummary: weatherSummary)
                weatherCellViewModels.append(weatherCellViewModel)
            }
            self!.weatherCellViewModels = weatherCellViewModels
            self!.eventOutput.send(.fetchSuccessWeatherCellViewModels(weatherCellViewModels: weatherCellViewModels))
        }.store(in: &cancellabels)
        
    }
    
    private func createWeatherCellViewModel(weatherSummary: WeatherSummary) -> WeatherCellViewModel{
        let location = weatherSummary.location
        let time =  weatherSummary.time == nil ? "" : TimeHandler.getTime(in: weatherSummary.time!)
        let condition = weatherSummary.condition == nil ? "" : weatherSummary.condition!
        let minTempC =  weatherSummary.minTempC == nil ? "" :  String(Int(round(weatherSummary.minTempC!)))
        let maxTempC = weatherSummary.maxTempC == nil ? "" : String(Int(round(weatherSummary.maxTempC!)))
        let currentDegreeC = weatherSummary.currentDegreeC == nil ? "" : String(Int(round(weatherSummary.currentDegreeC!)))
        let backgroundName = "sky3.jpeg"
        let isClearBackground = true
        
        let weatherCellViewModel = WeatherCellViewModel(location: location, time: time, condition: condition, lowDegree: minTempC, highDegree: maxTempC, currentDegree: currentDegreeC, backgroundName: backgroundName, isClearBackground: isClearBackground)
        return weatherCellViewModel
    }
        
    private func appendWeatherCellViewModel(weatherSummary: WeatherSummary){
        weatherSummarys.value[weatherSummarys.value.count] = weatherSummary
        delegate?.updateWeatherSummarys(weatherSummarys: weatherSummarys.value)
//        let weatherCellViewModel = createWeatherCellViewModel(weatherSummary: weatherSummary)
//        self.weatherCellViewModels.append(weatherCellViewModel)
        CoreDataHelper.shared.addNameLocationCoredata(locationName: weatherSummary.location)
//        eventOutput.send(.fetchSuccessWeatherCellViewModels(weatherCellViewModels: weatherCellViewModels))
        eventOutput.send(.isDeactiveSearch(isDeactive: true))
    }
 
    
    private func removeNameLocationCoreData(at index: Int){
        let location = weatherCellViewModels[index].location.value
        weatherSummarys.value.removeValue(forKey: index)
        delegate?.updateWeatherSummarys(weatherSummarys: weatherSummarys.value)
        delegate?.removeContentView(at: index)
//        weatherCellViewModels.remove(at: index)
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", location)
        do {
            let object = try context.fetch(fetchRequest).first
            context.delete(object!)
            try context.save()
        } catch _ {
            print("error delete coreData")
            // error handling
        }
        
//        update position
        
        let fetchAllLocation: NSFetchRequest<Location> = Location.fetchRequest()
        do{
            let objects = try context.fetch(fetchAllLocation)
            var i: Int16 = 0
            for object in objects{
                object.idOrder = i
                i += 1
                try context.save()
            }
        }catch{
            print("error update position")
        }
    }
    
    private func reorderLocationCoreData(sourcePosition: Int16, destinationPostion: Int16){
        
        if let value1 = weatherSummarys.value[Int(sourcePosition)], let value2 = weatherSummarys.value[Int(destinationPostion)] {
            weatherSummarys.value[Int(sourcePosition)] = value2
            weatherSummarys.value[Int(destinationPostion)] = value1
        }
        
        delegate?.updateWeatherSummarys(weatherSummarys: weatherSummarys.value)
        
//        let selectedItem = weatherCellViewModels[Int(sourcePosition)]
//        weatherCellViewModels.remove(at: Int(sourcePosition))
//        weatherCellViewModels.insert(selectedItem, at: Int(destinationPostion))
        delegate?.reorderContentView(sourcePosition: Int(sourcePosition), destinationPostion: Int(destinationPostion))
        var sourcePos = sourcePosition
        var desPos = destinationPostion
        if isForecastCurrentLocationWeather{
            sourcePos = sourcePos - 1
            desPos = desPos - 1
        }
        CoreDataHelper.shared.reorderLocationCoreData(sourcePosition: sourcePos, destinationPostion: desPos)
    }
}

extension SearchViewControllerViewModel: EventEditDelegate{
    func editListWeatherCell() {
        self.isHiddenEditView = true
        self.eventOutput.send(.isHiddenEditView(isHidden: self.isHiddenEditView))
        self.isEditMode = true
        self.eventOutput.send(.isEditMode(isEdit: true))
    }
    
    func changeToCel() {
        print("change to cel")
    }
    
    func changeToFah() {
        print("change to fah")
    }
    
    
}
