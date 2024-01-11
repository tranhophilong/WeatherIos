//
//  ContentViewControllerViewModel.swift
//  Weather
//
//  Created by Long Tran on 28/11/2023.
//

import Combine
import CoreData
import UIKit

class ContentViewControllerViewModel{
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let contentViewModel: ContentViewModel
    let addContentWeather = PassthroughSubject<Bool, Never>()
    let isCancelContentVC = PassthroughSubject<Bool, Never>()
    let isHiddenAddBtn = CurrentValueSubject<Bool, Never>(true)
    let weatherSummary = CurrentValueSubject<WeatherSummary, Never>(WeatherSummary(location: "", maxTempC: 0, maxTempF: 0, minTempC: 0, minTempF: 0, time: "", condition: "", currentDegreeF: 0, currentDegreeC: 0))
    private var cancellables = Set<AnyCancellable>()
    
    init(contentViewModel: ContentViewModel) {
        self.contentViewModel = contentViewModel
        contentViewModel.weatherSummary.sink { [weak self] weatherSummary in
            self?.weatherSummary.value = weatherSummary
        }.store(in: &cancellables)
        
        contentViewModel.isLoadFinished
            .sink {[weak self] isFinished in
            self!.isHiddenAddBtn.value = !isFinished
        }.store(in: &cancellables)
       
    }
     
}
