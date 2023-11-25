//
//  MainViewModel.swift
//  Weather
//
//  Created by Long Tran on 08/11/2023.
//

import UIKit
import Combine
import CoreData

class SearchViewModel{
    
    enum EventInput{
        case viewDidLoad
        case addLocation(nameLocation: String)
        case removeLocation(object: NSManagedObject)
    }
    
    enum DataOutput{
        case fetchDataFail
        case fetchSuccessWeatherItem(weatherItems: [WeatherItem])
    }
    
    let isEditDataWeather = CurrentValueSubject<Bool, Never>(false)
    let isShowEditView = CurrentValueSubject<Bool, Never>(false)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var cancellabels = Set<AnyCancellable>()
    let outputFetchData = PassthroughSubject<DataOutput, Never>()
    
    func transform(input: AnyPublisher<EventInput, Never>) -> AnyPublisher<DataOutput, Never>{
        input.sink {  [weak self]  event  in
            switch event{

            case .viewDidLoad:
                self!.getWeatherItems()
            case .addLocation(let nameLocation):
                self!.addNameLocationCoredata(locationName: nameLocation)
            case .removeLocation(let object):
                self!.deleteNameLocationCoreData(object: object)
            }
            
        }.store(in: &cancellabels)
        
        return outputFetchData.eraseToAnyPublisher()
    }
    
    //    MARK: - Data
    
    
    private func getWeatherItems(){
        
        let nameLocations = getNameLocationsCoreData()
        
        Task{[weak self] in
            do{
                var weatherItems: [WeatherItem] = []
                
                for name in nameLocations{
                      let forecastDay = try await WeatherService.shared.getDayForecastWeather(with: name).async()
                    let currentWeather = try await WeatherService.shared.getCurrentWeather(with: name).async()
                    
                    let forecastDayDetail = forecastDay.forecastday[0].day
                    let weatherItem = WeatherItem(location: name, time: String.getYearMonthDay(in: forecastDay.forecastday[0].date), condtion: forecastDayDetail.condition.text, lowDegree: String(Int(forecastDayDetail.mintempC)), highDegree:String(Int(forecastDayDetail.maxtempC)), currentDegree: String(Int(currentWeather.tempC)), background: UIImage(named: "blue-sky2.jpeg")!)
                    
                    weatherItems.append(weatherItem)
                    
                    self!.outputFetchData.send(.fetchSuccessWeatherItem(weatherItems: weatherItems))
                    
                   
                }
                
                
            }catch{
                print("fail")
            }
        }
        
      
        
       
    }
    
    private func addNameLocationCoredata(locationName: String){
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: context)
        let newLocation = NSManagedObject(entity: entity!, insertInto: context)
        
        newLocation.setValue(locationName, forKey: "name")
        
        do{
            try context.save()
        }catch{
            print("error saving")
        }
    }
    
    private func getNameLocationsCoreData() -> [String]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        request.returnsDistinctResults  = true
        var nameLocations: [String] = []
        
        do{
            let result = try context.fetch(request)

            for data in result as! [NSManagedObject]{
                nameLocations.append(data.value(forKey: "name") as! String)
            }
        }catch{
            print("faild get data")
        }
        
        return nameLocations
        
    }
    
    private func deleteNameLocationCoreData(object: NSManagedObject){
        context.delete(object)
        
        do{
           try context.save()
        }catch{
            print("fail delete")
        }
        
    }
    
    
}
