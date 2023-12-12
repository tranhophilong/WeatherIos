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


class MasterViewController: UIViewController, SearchViewcontrollerDelegate {
    
    func removeContentView(at index: Int) {
        print(index)
    }
    
    func reorderContentView(sourceIndex: Int, desIndex: Int) {
        print(sourceIndex)
    }
    
    
    func addContentView(contentView: ContentView) {
        
       print(contentView)
        
    }
    
    private let event = PassthroughSubject<MasterViewModel.EventMasterView, Never>()
    private lazy var containerView  = UIScrollView(frame: .zero)
    private lazy var bottomAppBarView = BottomAppBarView(frame: .zero)
    private lazy var backGroundImg = UIImageView(frame: .zero)
    private  let viewModel = MasterViewModel()
    private var cancellables = Set<AnyCancellable>()
    let locationManager = CLLocationManager()
    var weatherItems: [WeatherItem?] = []
    let searchView = SearchViewController()
    
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        setupContainerView()
        setupBottomAppBar()
        constraint()
        setupBindFetchData()
        setupLocationManager()
        searchView.delegate = self
        
        switch locationManager.authorizationStatus{
        case .notDetermined, .restricted, .denied:
            event.send(.viewDidLoad(currentCoordinateLocation: nil))
        case .authorizedAlways, .authorizedWhenInUse:
            searchView.isForecastCurrentWeather = true
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
        print("Testing commiting after deleting the Podfile")
    }
 
    private func setupLocationManager()  {
        
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global().async {[weak self] in
            if CLLocationManager.locationServicesEnabled() {
                self!.locationManager.delegate = self
                self!.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            }
        }
    }
    
    private func setupBindFetchData(){
        
        
//        event
        let outputDataWeather = viewModel.transform(input: event.eraseToAnyPublisher())
        outputDataWeather.sink {[weak self] outputFetchData in
            switch outputFetchData{
            case .fetchSuccsessContentViews(contentViews: let contentViews, isForecastCurrentWeather: let isForecastCurrentWeather):
                self!.addWeatherContentViews(contentViews: contentViews)
                if isForecastCurrentWeather{
                    self!.bottomAppBarView.setIndicatorLocationAtFirst()
                }
            case .fetchSuccsessWeatherItems(weatherItems: let weatherItems):
                self!.searchView.setWeatherItems(weatherItems: weatherItems)
            case .layoutContainerView(contentSize: let contentSize):
                self!.containerView.contentSize = contentSize
            case .layoutCurrentPageControl(currentPageControl: let currentPageControl):
                self!.bottomAppBarView.currentPage = currentPageControl
                self!.searchView.animationCellIndex = currentPageControl
            case .layoutNumberPageControl(numberPageControl: let numberPageControl):
                self!.bottomAppBarView.numberPageControll = numberPageControl
            case .imgContentViews(imgs: let imgs):
                self!.searchView.setImgContentView(imgContentViews: imgs)
            }
        }.store(in: &cancellables)
    }
    
  
    
    private func addWeatherContentViews(contentViews: [ContentView]){
        
        for subview in containerView.subviews{
            subview.removeFromSuperview()
        }
        
        for contentView in contentViews{
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
        
        let navController = UINavigationController(rootViewController: searchView)
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        navigationController?.present(navController, animated: true)
     
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
}

