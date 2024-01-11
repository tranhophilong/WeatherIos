//
//  SearchCoordinator.swift
//  Weather
//
//  Created by Long Tran on 03/01/2024.
//

import UIKit
import Combine

class SearchCoordinator: BaseCoordinator{
    
    
    private var cancellables = Set<AnyCancellable>()
    let vcPresent: UIViewController
    let isForecastCurrentWeather: Bool
  
    lazy var searchView: SearchViewController = {
       let searchViewModel  =  SearchViewControllerViewModel(isForecastCurrentWeather: isForecastCurrentWeather)
       let searchVC = SearchViewController(viewModel: searchViewModel)
       return searchVC
    }()
    
    init(vcPresent: UIViewController, isForecastCurrentWeather: Bool) {
        self.vcPresent = vcPresent
        self.isForecastCurrentWeather = isForecastCurrentWeather
    }
    
    override func start() {
        let nav = UINavigationController(rootViewController: searchView)
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .crossDissolve
        vcPresent.present(nav, animated: true)
        
        searchView.searchResultViewModel.presentContentViewController.sink { [weak self] contentViewModel in
            self?.presentContentVC(contentViewModel: contentViewModel)
        }.store(in: &cancellables)
        
        if let vcPresent = vcPresent as? MasterViewController{
            searchView.viewModel.delegate = vcPresent.viewModel
            vcPresent.viewModel.weatherSummarys.sink {[weak self] weatherSymmarys in
                self?.searchView.viewModel.weatherSummarys.value = weatherSymmarys
            }.store(in: &cancellables)
        }
        
        searchView.viewModel.backToMasterVC.sink {[weak self] index in
            
            if let vcPresent = self?.vcPresent as? MasterViewController{
                vcPresent.event.send(.back(index: index))
            }
            self?.searchView.dismiss(animated: true, completion: {
                self?.isCompleted?()

            })
        }.store(in: &cancellables)
    }
    
    func presentContentVC(contentViewModel: ContentViewModel){
        let contentVCCoordinator = ContentViewControllerCoordinator(contentViewModel, vcPresent: self.searchView)
        contentVCCoordinator.start()
        store(coordinator: contentVCCoordinator)
        contentVCCoordinator.isCompleted = { [weak self] in
            print("free contentVCCoordinator")
            self?.free(coordinator: contentVCCoordinator)
        }
       
    }
    
    
}

