//
//  ViewController.swift
//  Weather
//
//  Created by Long Tran on 19/10/2023.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>() // (3)
    
    var weatherData : WeatherLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        
        WeatherData.shared.getForecastOfDay(with: Coordinates(longitude: 10.85 , latitude: 106.60))
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion{
                case .finished:
                    print("finished")
                case .failure(let err):
                    print("Error is \(err.localizedDescription)")
                }
            } receiveValue: { data in
                print(data)
            }.store(in: &cancellables)

    }
}
