//
//  WeatherViewController.swift
//  Weather
//
//  Created by Long Tran on 21/10/2023.
//

import UIKit
import SnapKit
import Combine
import CoreLocation


class MasterViewController: UIViewController {
    
    let event = PassthroughSubject<MasterViewModel.EventMasterView, Never>()
    private lazy var containerView  = UIScrollView(frame: .zero)
    private lazy var backGroundImg = UIImageView(frame: .zero)
    let viewModel = MasterViewModel()
    let bottomAppBarViewModel = BottomAppBarViewModel()
    private lazy var bottomAppBarView = BottomAppBarView(frame: .zero, viewModel: bottomAppBarViewModel)
    private var cancellables = Set<AnyCancellable>()
    private let locationManager = CLLocationManager()
    private let sizeContainerView = CGSize(width: SCREEN_WIDTH(), height: SCREEN_HEIGHT())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
        constraint()
        setupBindFetchData()
        setupLocationManager()
        
    }
 
    private func setupLocationManager() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.delegate = self
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerView.layoutIfNeeded()
        containerView.layoutSubviews()
    }
    
    private func setupBindFetchData(){
        let outputDataWeather = viewModel.transform(input: event.eraseToAnyPublisher())
        outputDataWeather.sink {[weak self] outputFetchData in
            switch outputFetchData{
            case .layoutCurrentPageControl(currentPageControl: let currentPageControl):
                self!.bottomAppBarViewModel.changeCurrentPageControl(currentPage: currentPageControl)
            case .layoutNumberPageControl(numberPageControl: let numberPageControl):
                self!.bottomAppBarViewModel.changeNumberPageControl(number: numberPageControl)
                self!.containerView.contentSize = CGSize(width: CGFloat(numberPageControl) * self!.sizeContainerView.width , height: self!.sizeContainerView.height)
            case .fetchSuccessContentViewModels(contentViewModels: let contentViewModels):
                self?.setupContentViews(contentViewModels: contentViewModels)
            case .setContentOffSet(index: let index):
                self?.containerView.setContentOffset(CGPoint(x: Int(self!.sizeContainerView.width) * index, y: 0), animated: true)
            case .removeContentView(index: let index):
                self?.removeContentView(at: index)
            case .reorderContentView(sourcePosition: let sourcePosition, destinationPosition: let destinationPosition):
                self?.reorderContentView(sourcePosition: sourcePosition, destinationPosition: destinationPosition)
            case .appendContentView(contentViewModel: let contentViewModel):
                self?.appendContentView(contentViewModel: contentViewModel)
            }
        }.store(in: &cancellables)
    }
    
    private func appendContentView(contentViewModel: ContentViewModel){
        let frameX = containerView.subviews.last!.frame.maxX
        
        let frameContentView = CGRect(x: frameX , y: 0, width: sizeContainerView.width, height: sizeContainerView.height)
        let contentView = ContentView(frame: frameContentView, viewModel: contentViewModel)
     
        containerView.addSubview(contentView)
        containerView.layoutSubviews()
     
    }
    
    private func removeContentView(at index: Int){
        
        containerView.subviews[index].removeFromSuperview()
        
        for i in 0..<containerView.subviews.count{
            let frame =  CGRect(x: CGFloat(i) * sizeContainerView.width, y: 0, width: sizeContainerView.width, height: sizeContainerView.height)
            containerView.subviews[i].frame = frame
            
        }
        
    }
    
    private func reorderContentView(sourcePosition: Int, destinationPosition: Int){
        let sourceContentViewFrame = containerView.subviews[sourcePosition].frame
        let destinationContententVivewFrame = containerView.subviews[destinationPosition].frame
        containerView.subviews[sourcePosition].frame = destinationContententVivewFrame
        containerView.subviews[destinationPosition].frame = sourceContentViewFrame
        containerView.exchangeSubview(at: sourcePosition, withSubviewAt: destinationPosition)
    }
      
    private func setupContentViews(contentViewModels: [ContentViewModel]){
        
        for subview in containerView.subviews{
            subview.removeFromSuperview()
        }
                
        for i in 0..<contentViewModels.count{
            let contentView = ContentView(frame: CGRect(x: CGFloat(i) * sizeContainerView.width, y: 0, width: sizeContainerView.width, height: sizeContainerView.height), viewModel: contentViewModels[i])
            containerView.addSubview(contentView)
        }
    }
    
    private func setupContainerView(){
        containerView.backgroundColor = .clear
        containerView.isPagingEnabled = true
        containerView.showsHorizontalScrollIndicator = false
        containerView.delegate = self
        
    }
    
    private func constraint(){
        view.addSubview(backGroundImg)
        view.addSubview(containerView)
        view.addSubview(bottomAppBarView)
      
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        bottomAppBarView.snp.makeConstraints { make in
            make.height.equalTo(80.VAdapted)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
            
        backGroundImg.image = UIImage(named: "sky3.jpeg")
        backGroundImg.contentMode = .scaleAspectFill
        backGroundImg.clipsToBounds = true
                                
        backGroundImg.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}


//MARK: -scroll action

extension MasterViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.changePageControl(with: scrollView.contentOffset.x)
    }

}

// MARK: - Location delegate

extension MasterViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else{
            return
        }
        event.send(.viewDidLoad(currentCoordinateLocation: "\(first.coordinate.latitude),\(first.coordinate.longitude)"))
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus{
        case .notDetermined, .restricted, .denied:
            print("Undefine authorization status")
            event.send(.viewDidLoad(currentCoordinateLocation: nil))
//            bottomAppBarViewModel.isIndicatorLocationFirst.value = false
        case .authorizedAlways, .authorizedWhenInUse:
            print("authorization status")
            locationManager.startUpdatingLocation()
//            bottomAppBarViewModel.isIndicatorLocationFirst.value = true
        @unknown default:
            break
        }
    }
}

