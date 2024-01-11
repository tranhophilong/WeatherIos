//
//  MasterCoordinator.swift
//  Weather
//
//  Created by Long Tran on 03/01/2024.
//

import UIKit
import Combine

class MasterCoordinator: BaseCoordinator{
    
    private var cancellabels = Set<AnyCancellable>()
    let window: UIWindow
    let masterVC = {
        let masterVC = MasterViewController()
        return masterVC
    }()
    
    init(window: UIWindow){
        self.window = window
    }
    
    override func start() {
       
//        Present
        masterVC.bottomAppBarViewModel.navToSearchView.sink { [weak self] isNavToSearchView in
            let isForecastCurrentWeather = self!.masterVC.viewModel.isForeCastCurrentWeather.value
            self?.presentSearchView(isForecastCurrentWeather: isForecastCurrentWeather)
        }.store(in: &cancellabels)
        window.rootViewController = masterVC
        window.makeKeyAndVisible()
    }
    
    func presentSearchView(isForecastCurrentWeather: Bool){
        let searchCoordinator = SearchCoordinator(vcPresent: self.masterVC, isForecastCurrentWeather: isForecastCurrentWeather)
        searchCoordinator.start()
        self.store(coordinator: searchCoordinator)
        
        searchCoordinator.isCompleted = { [weak self] in
            print("free searchCoor")
            self?.free(coordinator: searchCoordinator)
        }

    }
}



