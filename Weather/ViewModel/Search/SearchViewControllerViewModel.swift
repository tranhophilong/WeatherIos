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

class SearchViewControllerViewModel{
    
    enum EventInput{
        case addWeatherItem
        case removeLocation(index: Int)
        case reorderLocation(sourcePosition: Int16, destinationPosition: Int16)
        case changeHiddenStateEditView
        case hiddenEditView
        case changeStateEditMode(isEdit: Bool)
    }
    
    enum DataOutput{
        case fetchDataFail
        case fetchSuccessWeatherCellViewModels(weatherCellViewModels: [WeatherCellViewModel])
        case isForecastCurrentWeather(isForecast: Bool)
        case isHiddenEditView(isHidden: Bool)
        case isEditMode(isEdit: Bool)
    }
    
    private var isForecastCurrentLocationWeather = false
    private var weatherCellViewModels = [WeatherCellViewModel]()
    private var isEditMode = false
    private var isHiddenEditView = false
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var cancellabels = Set<AnyCancellable>()
    let outputFetchData = PassthroughSubject<DataOutput, Never>()
    
    init(weatherCellViewModels: [WeatherCellViewModel]){
        self.weatherCellViewModels = weatherCellViewModels
        self.outputFetchData.send(.fetchSuccessWeatherCellViewModels(weatherCellViewModels: weatherCellViewModels))
        self.outputFetchData.send(.isHiddenEditView(isHidden: isHiddenEditView))
        self.outputFetchData.send(.isEditMode(isEdit: isEditMode))
    }
    
    func transform(input: AnyPublisher<EventInput, Never>) -> AnyPublisher<DataOutput, Never>{
        input.sink {  [weak self]  event  in
            switch event{
            case .addWeatherItem:
                self!.appendLastWeatherCellViewModel()
                self?.outputFetchData.send(.fetchSuccessWeatherCellViewModels(weatherCellViewModels: self!.weatherCellViewModels))
            case .reorderLocation(sourcePosition: let sourcePosition, destinationPosition: let destinationPosition):
                self!.reorderLocationCoreData(sourcePosition: sourcePosition, destinationPostion: destinationPosition)
                self?.outputFetchData.send(.fetchSuccessWeatherCellViewModels(weatherCellViewModels: self!.weatherCellViewModels))
            case .changeHiddenStateEditView:
                self?.isHiddenEditView = !self!.isHiddenEditView
                self?.outputFetchData.send(.isHiddenEditView(isHidden: self!.isHiddenEditView))
            case .hiddenEditView:
                self?.isHiddenEditView = false
                self?.outputFetchData.send(.isHiddenEditView(isHidden: self!.isHiddenEditView))
            case .changeStateEditMode(isEdit: let isEdit):
                self?.isEditMode = isEdit
                self?.outputFetchData.send(.isEditMode(isEdit: isEdit))
            case .removeLocation(index: let index):
                self?.removeNameLocationCoreData(at: index)
                self?.outputFetchData.send(.fetchSuccessWeatherCellViewModels(weatherCellViewModels: self!.weatherCellViewModels))
            }
            
        }.store(in: &cancellabels)
        
        return outputFetchData.eraseToAnyPublisher()
    }
    
    //    MARK: - Data
    
    private func appendLastWeatherCellViewModel(){
        let location = CoreDataHelper.shared.getNameLocationsCoreData().last!
        Task{[weak self] in
            
            do{
                try await self!.appendWeatherCellViewModel(with: location)
            }catch{
                self?.outputFetchData.send(.fetchDataFail)
            }
        }
    }
    
    private func appendWeatherCellViewModel(with location: String) async throws{
            
        async let forecastDay = WeatherService.shared.getDayForecastWeather(with: location).async()
        async let currentWeather =  WeatherService.shared.getCurrentWeather(with: location).async()
        let forecastDayDetail = try await forecastDay.forecastday[0].day
        let weatherCellViewModel = try await WeatherCellViewModel(location: location, time: TimeHandler.getYearMonthDay(in: forecastDay.forecastday[0].date), condition: forecastDayDetail.condition.text, lowDegree: String(Int(forecastDayDetail.mintempC)), highDegree: String(Int(forecastDayDetail.maxtempC)), currentDegree: String(Int(currentWeather.tempC)), backgroundName: "sky4.jpeg", isClearBackground: false)
     
        weatherCellViewModels.append(weatherCellViewModel)
  
    }
    
    private func removeNameLocationCoreData(at index: Int){
        weatherCellViewModels.remove(at: index)
        let location = weatherCellViewModels[index].location.value
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
        let selectedItem = weatherCellViewModels[Int(sourcePosition)]
        weatherCellViewModels.remove(at: Int(sourcePosition))
        weatherCellViewModels.insert(selectedItem, at: Int(destinationPostion))
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
        self.isHiddenEditView = false
        self.outputFetchData.send(.isHiddenEditView(isHidden: self.isHiddenEditView))
        self.isEditMode = true
        self.outputFetchData.send(.isEditMode(isEdit: true))
    }
    
    func changeToCel() {
        print("change to cel")
    }
    
    func changeToFah() {
        print("change to fah")
    }
    
    
}
