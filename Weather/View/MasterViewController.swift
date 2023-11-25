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
    private lazy var bottomAppBarView = BottomAppBarView(frame: .zero)
    private lazy var backGroundImg = UIImageView(frame: .zero)
    private  let viewModel = MasterViewModel()
    private var cancellables = Set<AnyCancellable>()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        setupContainerView()
        setupBottomAppBar()
        constraint()
        setupBindScroll()
        setupBindFetchData()
        setupCurrentLocation()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    private func setupCurrentLocation()  {
                self.locationManager.requestAlwaysAuthorization()
                // For use in foreground
                self.locationManager.requestWhenInUseAuthorization()
                DispatchQueue.global().async {[weak self] in
                    if CLLocationManager.locationServicesEnabled() {
                        self!.locationManager.delegate = self
                        self!.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                        self!.locationManager.startUpdatingLocation()
                    }
                }
    }
    
    private func setupBindFetchData(){
//        event
        let outputDataWeather = viewModel.transform(input: event.eraseToAnyPublisher())
        
        outputDataWeather.sink { outputFetchData in
            switch outputFetchData{
           
            }
        }.store(in: &cancellables)
    }
    
    private func setupBindScroll(){
        viewModel.numberSubviews.sink {[weak self] num in
            for i in 0..<num{
                let view = ContentView(frame: CGRectMake(CGFloat(i) * self!.viewModel.contentSize.width, 0, self!.viewModel.contentSize.width, self!.viewModel.contentSize.height), coor: nil, nameLocation: "Ho Chi Minh")
                self!.containerView.addSubview(view)
            }
        }.store(in: &cancellables)
        
        
        
        viewModel.currentPageControl.sink {[weak self] index in
            self!.bottomAppBarView.currentPage = index
        }.store(in: &cancellables)
        
    }
    
    
    private func setupContainerView(){
        containerView.backgroundColor = .clear
        containerView.contentSize = CGSize(width: viewModel.contentSize.width * CGFloat(viewModel.numberSubviews.value), height: viewModel.contentSize.height)
        containerView.isPagingEnabled = true
        containerView.showsHorizontalScrollIndicator = false
        containerView.delegate = self
        

    }
    
    private func setupBottomAppBar(){
        bottomAppBarView.numberPageControll =  viewModel.numberSubviews.value
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(navToSearchView))
        bottomAppBarView.showLstContentBtn.isUserInteractionEnabled = true
        bottomAppBarView.showLstContentBtn.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func navToSearchView(){
         let searchView = SearchViewController()
//        searchView.modalPresentationStyle = .overCurrentContext
        let navController = UINavigationController(rootViewController: searchView)
        navController.modalPresentationStyle = .fullScreen
//        searchView.modalPresentationCapturesStatusBarAppearance = false
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
        
        print(first.coordinate.latitude, first.coordinate.longitude)
        
       
        
    }
}
