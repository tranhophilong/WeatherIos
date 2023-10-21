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

class WeatherData{
    
    static let shared = WeatherData()
    private var cancellables = Set<AnyCancellable>()
    static let baseEndpoint = "http://api.weatherapi.com/v1/forecast.json?key=22e2d2eefe404b6c87c81352231609";

    func getForecastOfDay(with coor : Coordinates) -> Future<WeatherLocation, Error> {
        
        let endpoint = WeatherData.baseEndpoint  + "&q=\(coor.longitude),\(coor.latitude)"

        return Future<WeatherLocation, Error> { [weak self] promise in
            guard let url = URL(string: endpoint) else{
                return promise(.failure(NetworkError.invalidURL))
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data: Data, response: URLResponse) in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    
                    let jsonForecastOfDay =  try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    guard let dataForecastOfDay =  WeatherLocation(json: jsonForecastOfDay!) else{
                        throw NetworkError.failDecode
                    }
                    return dataForecastOfDay
                    
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

