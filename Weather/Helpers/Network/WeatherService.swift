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
    static let forecastEndpoint = "http://api.weatherapi.com/v1/forecast.json?key=22e2d2eefe404b6c87c81352231609"
    static let currentWeatherEndpoint = "http://api.weatherapi.com/v1/current.json?key=22e2d2eefe404b6c87c81352231609";
    
    private func getCurrentDay(in localTime: String) -> String{
        let startIndex = localTime.index(localTime.startIndex, offsetBy: 8)
        let endIndex = localTime.index(localTime.startIndex, offsetBy: 9)
        
        return String(localTime[startIndex...endIndex])
    }
    
    private func getCurrentHour(in localTime: String) -> String{
        let startIndex = localTime.index(localTime.startIndex, offsetBy: 11)
        let endIndex = localTime.index(localTime.startIndex, offsetBy: 12)
        
        return String(localTime[startIndex...endIndex])
    }
    
    private func getTime(in localTime: String) -> String{
        let startIndex = localTime.index(localTime.startIndex, offsetBy: 0)
        let endIndex = localTime.index(localTime.startIndex, offsetBy: 9)
        
        return String(localTime[startIndex...endIndex])
    }
    
  
    
    private func getHourlyForeCastWeather(with coor: Coordinates, hour: String, dt: String) -> Future<HourlyForecastWeather,Error>{
        let endpoint = WeatherService.forecastEndpoint  + "&q=\(coor.longitude),\(coor.latitude)&hour=\(hour)&dt=\(dt)"

                return Future<HourlyForecastWeather, Error> { [weak self] promise in
                    guard let url = URL(string: endpoint) else{
                        return promise(.failure(NetworkError.invalidURL))
                    }
                    
                    URLSession.shared.dataTaskPublisher(for: url)
                        .tryMap { (data: Data, response: URLResponse) in
                            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                                throw NetworkError.responseError
                            }
                        }
                        .receive(on: RunLoop.main)
                        .sink { completion in
                            if case let .failure(error) = completion {
                                switch error{
                                case let apiError as NetworkError:
                                    promise(.failure(apiError))

                                default:
                                    promise(.failure(NetworkError.unknown))
                                }
                            }
                        } receiveValue: { data in
                            promise(.success(data))
                        }.store(in: &self!.cancellables)

                        }
                }
    
    
   
        
    }

    





