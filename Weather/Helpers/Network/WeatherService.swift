//
//  WeatherData.swift
//  Weather
//
//  Created by Long Tran on 20/10/2023.
//

import Combine
import Foundation


enum NetworkError: Error {
    case invalidURL
    case responseError
    case failDecode
    case unknown
}



extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "")
        case .failDecode:
            return NSLocalizedString("Fail Decode data", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "")
        }
     
    }
}

class WeatherService{
    
    static let shared = WeatherService()
    private var cancellables = Set<AnyCancellable>()
    static let forecastWeatherEndpoint = "http://api.weatherapi.com/v1/forecast.json?key=22e2d2eefe404b6c87c81352231609"
    static let currentWeatherEndpoint = "http://api.weatherapi.com/v1/current.json?key=22e2d2eefe404b6c87c81352231609";
        
    func get10NextDayForecastWeather(with coor: Coordinate?, nameLocation: String)  -> Future<([Forecast], String), Error>{
            var urlLocationWeather = WeatherService.currentWeatherEndpoint
            var urlDayForecastWeather = WeatherService.forecastWeatherEndpoint
            
            if let coor = coor{
                 urlLocationWeather = urlLocationWeather + "&q=\(coor.lat),\(coor.lon)"
                  urlDayForecastWeather = urlDayForecastWeather + "&q=\(coor.lat),\(coor.lon)"
            }else{
                urlLocationWeather = urlLocationWeather + "&q=\(nameLocation)"
                urlDayForecastWeather = urlDayForecastWeather + "&q=\(nameLocation)"
              
            }
              return  fetch10NextDayForecastWeather(urlLocationWeather: urlLocationWeather, urlDayForecastWeather: urlDayForecastWeather)
   
    }
    
    
    
//    MARK: - Location weather
    
    
    func getLocationWeather(with coor: Coordinate) -> AnyPublisher<LocationWeather, Error>{
        let endPoint = WeatherService.currentWeatherEndpoint + "&q=\(coor.lat),\(coor.lon)"
        
        return fetchLocationWeather(with: endPoint)
        
    }
    
    func getLocationWeather(with nameLocation: String) -> AnyPublisher<LocationWeather, Error>{
        let endPoint = WeatherService.currentWeatherEndpoint + "&q=\(nameLocation)"
        
        return fetchLocationWeather(with: endPoint)
    }
    
//    MARK: - Day forecast
    
    func getDayForecastWeather(with coor: Coordinate, and day: String)  -> AnyPublisher<Forecast, Error>{
        let endPoint = WeatherService.forecastWeatherEndpoint + "&q=\(coor.lat),\(coor.lon)&dt=\(day)"
        
       return   fetchDayForecastWeather(with: endPoint)
    }
    
    func getDayForecastWeather(with nameLocation: String, and day: String)  -> AnyPublisher<Forecast, Error>{
        let endPoint = WeatherService.forecastWeatherEndpoint + "&q=\(nameLocation)&dt=\(day)"
        
       return   fetchDayForecastWeather(with: endPoint)
    }
    
    func getDayForecastWeather(with nameLocation: String) -> AnyPublisher<Forecast, Error>{
        let endPoint = WeatherService.forecastWeatherEndpoint + "&q=\(nameLocation)"
        
        return fetchDayForecastWeather(with: endPoint)
    }
    
//    MARK: - Current weather
    
    func getCurrentWeather(with coor: Coordinate) -> AnyPublisher<CurrentWeather, Error>{
        let endPoint = WeatherService.currentWeatherEndpoint + "&q=\(coor.lat),\(coor.lon)"
        
        return fetchCurrentWeather(with: endPoint)
    }
    
    func getCurrentWeather(with nameLocation: String) -> AnyPublisher<CurrentWeather, Error>{
        let endPoint = WeatherService.currentWeatherEndpoint + "&q=\(nameLocation)"
        
        return fetchCurrentWeather(with: endPoint)
    }
    
    
    
    
//    MARK: - Fetch data
    func fetchCurrentWeather(with url: String) -> AnyPublisher<CurrentWeather, Error>{
        return fetchData(with: url)
            .map { weather in
                weather.current
            }.eraseToAnyPublisher()
    }
    
    private func fetch10NextDayForecastWeather(urlLocationWeather: String, urlDayForecastWeather: String) -> Future<([Forecast], String), Error>{
        
        return  Future<([Forecast], String), Error>{ [weak self] promise in
            self!.fetchLocationWeather(with: urlLocationWeather)
                .sink { completion in
                    if case let .failure(error) = completion {
                        switch error{
                        case let apiError as NetworkError:
                            promise(.failure(apiError))

                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                } receiveValue: {   [weak self] location  in
                    Task{ [weak self] in
                        do{
                            var lstForecast : [Forecast] = []
                            var time = String.getYearMonthDay(in: location.localtime)
                              for   _ in 1...10{
//                                  print(time)
                                  let dayForecast = time
                                  let urlForecast = urlDayForecastWeather + "&dt=\(dayForecast)"
                                  let forcast = try await self!.fetchDayForecastWeather(with: urlForecast).async()
                                  time = String.convertNextDate(dateString: time)
                                  lstForecast.append(forcast)
                            }
                            promise(.success((lstForecast, location.name)))
                        }catch{
                            promise(.failure(NetworkError.failDecode))
                        }
                    }
                }.store(in: &self!.cancellables)
        }
            
    }
    
    private func fetchLocationWeather(with url: String) -> AnyPublisher<LocationWeather, Error>{
        return fetchData(with: url)
            .map { weather in
                weather.location
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchDayForecastWeather(with url: String) -> AnyPublisher<Forecast, Error>{
        return fetchData(with: url)
            .map { weather in
                weather.forecast!
            }
            .eraseToAnyPublisher()
    }
    
    
   
    
    
    private func fetchData(with url: String) -> AnyPublisher<Weather, Error>{
        return URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
          .tryMap { result in
              guard let res = result.response as? HTTPURLResponse else{
                  throw NetworkError.responseError
              }
              return result.data
          }
          .receive(on: DispatchQueue.global(qos: .background))
          .decode(type: Weather.self, decoder: JSONDecoder())
          .eraseToAnyPublisher()
    }
 
    
   
    
//    MARK: - Helper func
    private func getYearMonthDay(in localTime: String) -> String{
        let startIndex = localTime.index(localTime.startIndex, offsetBy: 0)
        let endIndex = localTime.index(localTime.startIndex, offsetBy: 9)
        
        return String(localTime[startIndex...endIndex])
    }
    
    }


