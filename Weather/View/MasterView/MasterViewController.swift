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
    
    private let event = PassthroughSubject<MasterViewModel.EventMasterView, Never>()
    private lazy var containerView  = UIScrollView(frame: .zero)
    private lazy var backGroundImg = UIImageView(frame: .zero)
    private  let viewModel = MasterViewModel()
    private let bottomAppBarViewModel = BottomAppBarViewModel()
    private lazy var bottomAppBarView = BottomAppBarView(frame: .zero, viewModel: bottomAppBarViewModel)
    private var cancellables = Set<AnyCancellable>()
    private let locationManager = CLLocationManager()
    private let sizeContainerView = CGSize(width: SCREEN_WIDTH(), height: SCREEN_HEIGHT())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
        setupBottomAppBar()
        constraint()
        setupBindFetchData()
        setupLocationManager()
        switch locationManager.authorizationStatus{
        case .notDetermined, .restricted, .denied:
            event.send(.viewDidLoad(currentCoordinateLocation: nil))
            bottomAppBarViewModel.isIndicatorLocationFirst.value = false
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            bottomAppBarViewModel.isIndicatorLocationFirst.value = true
        @unknown default:
            break
        }
    }
 
    private func setupLocationManager() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global().async {[weak self] in
            if CLLocationManager.locationServicesEnabled() {
                self!.locationManager.delegate = self
                self!.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            }
        }
    }
    
    private func setupBindFetchData(){
        let outputDataWeather = viewModel.transform(input: event.eraseToAnyPublisher())
        outputDataWeather.sink {[weak self] outputFetchData in
            switch outputFetchData{
            case .layoutCurrentPageControl(currentPageControl: let currentPageControl):
                self!.bottomAppBarViewModel.changeCurrentPageControl(currentPage: currentPageControl)
            case .layoutNumberPageControl(numberPageControl: let numberPageControl):
                self!.bottomAppBarViewModel.changeNumberPageControl(number: numberPageControl)
            case .fetchSuccessContentViewModels(contentViewModels: let contentViewModels):
                self?.setupContentViews(contentViewModels: contentViewModels)
            }
        }.store(in: &cancellables)
    }
      
    private func setupContentViews(contentViewModels: [ContentViewModel]){
        
        for subview in containerView.subviews{
            subview.removeFromSuperview()
        }
        
        containerView.contentSize = CGSize(width: CGFloat(contentViewModels.count) * sizeContainerView.width , height: sizeContainerView.height)
        
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
    
    private func setupBottomAppBar(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(navToSearchView))
        bottomAppBarView.showLstContentBtn.isUserInteractionEnabled = true
        bottomAppBarView.showLstContentBtn.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func navToSearchView(){
        
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
            
        backGroundImg.image = UIImage(named: "blue-sky2.jpeg")
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
}

