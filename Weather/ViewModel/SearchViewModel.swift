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

class SearchViewModel{
    
    enum EventInput{
        case addWeatherItem
        case removeLocation(location: String)
        case reorderLocation(sourcePosition: Int16, destinationPosition: Int16, isForecastCurrentWeather: Bool)
    }
    
    enum DataOutput{
        case fetchDataFail
        case addSuccessWeatherItem(weatherItem: WeatherItem)
    }
    
    let isEditDataWeather = CurrentValueSubject<Bool, Never>(false)
    let isShowEditView = CurrentValueSubject<Bool, Never>(false)
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var cancellabels = Set<AnyCancellable>()
    let outputFetchData = PassthroughSubject<DataOutput, Never>()
    
    func transform(input: AnyPublisher<EventInput, Never>) -> AnyPublisher<DataOutput, Never>{
        input.sink {  [weak self]  event  in
            switch event{
            case .removeLocation(let location):
                self!.deleteNameLocationCoreData(location: location)
            case .addWeatherItem:
                self!.getLastWeatherItem()
            case .reorderLocation(sourcePosition: let sourcePosition, destinationPosition: let destinationPosition, isForecastCurrentWeather: let isForecastCurrentWeather):
                self!.reorderLocationCoreData(sourcePosition: sourcePosition, destinationPostion: destinationPosition, isForcastCurrentWeather: isForecastCurrentWeather)
            }
        }.store(in: &cancellabels)
        
        return outputFetchData.eraseToAnyPublisher()
    }
    
    //    MARK: - Data
    
    private func getLastWeatherItem(){
        
        let location = CoreDataHelper.shared.getNameLocationsCoreData().last!
        Task{[weak self] in
            do{
                let weatherItem = try await self!.getWeatherItem(with: location)
                self!.outputFetchData.send(.addSuccessWeatherItem(weatherItem: weatherItem))
            }catch{
                self!.outputFetchData.send(.fetchDataFail)
            }
        }
    }
    
    private func getWeatherItem(with location: String) async throws -> WeatherItem   {
        
            async let forecastDay = WeatherService.shared.getDayForecastWeather(with: location).async()
            async let currentWeather =  WeatherService.shared.getCurrentWeather(with: location).async()
            let forecastDayDetail = try await forecastDay.forecastday[0].day
            let weatherItem =  try await WeatherItem(location: location, time: String.getYearMonthDay(in: forecastDay.forecastday[0].date), condtion: forecastDayDetail.condition.text, lowDegree: String(Int(forecastDayDetail.mintempC)) , highDegree:String(Int(forecastDayDetail.maxtempC)), currentDegree: String(Int(currentWeather.tempC)) + "°", background: UIImage(named: "sky4.jpeg")!)
            return weatherItem
  
    }
    
    private func deleteNameLocationCoreData(location: String){
        
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
    
    private func reorderLocationCoreData(sourcePosition: Int16, destinationPostion: Int16, isForcastCurrentWeather: Bool){
        
        var sourcePos = sourcePosition
        var desPos = destinationPostion
        if isForcastCurrentWeather{
            sourcePos = sourcePos - 1
            desPos = desPos - 1
        }
        CoreDataHelper.shared.reorderLocationCoreData(sourcePosition: sourcePos, destinationPostion: desPos)
       
    }
    
    

}
