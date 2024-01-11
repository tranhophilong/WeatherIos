//
//  ContentViewControllerCoordinator.swift
//  Weather
//
//  Created by Long Tran on 05/01/2024.
//

import UIKit
import Combine

class ContentViewControllerCoordinator: BaseCoordinator{
    
    let contentViewModel: ContentViewModel
    let vcPresent: UIViewController
    private var cancellabels = Set<AnyCancellable>()
    
    lazy var contentViewController: ContentViewController = {
        let contentViewControllerViewModel = ContentViewControllerViewModel(contentViewModel: contentViewModel)
        let contentViewController = ContentViewController(viewModel: contentViewControllerViewModel)
        return contentViewController
    }()
    
    init(_ contentViewModel: ContentViewModel, vcPresent: UIViewController) {
        self.vcPresent = vcPresent
        self.contentViewModel = contentViewModel
    }
    
    override func start() {
        vcPresent.present(contentViewController, animated: true)
        
        contentViewController.viewModel.addContentWeather.sink {[weak self] isAddContentWeather in
            if isAddContentWeather{
                if let searchVC = self?.vcPresent as? SearchViewController{
                    searchVC.event.send(.addWeatherCellViewModel(weatherSummary: self!.contentViewController.viewModel.weatherSummary.value))
                    searchVC.event.send(.addContentView(contentViewModel: self!.contentViewModel))
                }
                self?.contentViewController.dismiss(animated: true, completion: {
                    self?.isCompleted?()
                })
            }
        }.store(in: &cancellabels)
        
        contentViewController.viewModel.isCancelContentVC.sink {[weak self] isCancel in
            if isCancel{
                self?.contentViewController.dismiss(animated: true) {
                    self?.isCompleted?()
                }
            }
        }.store(in: &cancellabels)
    }
}


