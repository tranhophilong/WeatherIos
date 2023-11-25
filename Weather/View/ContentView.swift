//
//  ContentView.swift
//  Weather
//
//  Created by Long Tran on 22/10/2023.
//

import UIKit
import SnapKit
import Combine

class ContentView: UIView{
    
    private lazy var containerView = UIScrollView(frame: .zero)
    private lazy var headerContent = HeaderContentView(frame: .zero)
    private lazy var bodyContent = BodyContentView(frame: .zero)
    private lazy var uvBar = TempBarGradientColorView(frame: .zero)
    private var heightHeaderContentConstraint: Constraint?
    private var heightBodyContent: CGFloat = 0
    private var contentOffSetDidScroll: CGFloat = 0
    private var didGetContentOffSetDidScroll: Bool = false
    private var cardViewItems: [CardViewItem] = []
    private lazy var hourlyForecastView = HourlyForecastView(frame: CGRect(x: 0, y: 0, width: self.frame.width * 90/100 , height: 180.VAdapted))
    private lazy var tenDayForecastView =  TenDayForecastView(frame: CGRect(x: 0, y: 0, width: self.frame.width * 90/100 , height: 600.VAdapted))
    let event = PassthroughSubject<ContentViewModel.EventInput, Never>()
    private let viewModel = ContentViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    
    public  init(frame: CGRect, coor: Coordinate?, nameLocation: String) {
        super.init(frame: frame)
        setupHourlyForecastTenDayForecastView()
        setupContainerView()
        constraint()
        setupBinderChangeView()
        setupBinderGetData()
        
        if let coor = coor{
            event.send(.initViewWithCoor(coor: coor))
        }else{
            event.send(.initViewWithNameLocation(nameLocation: nameLocation))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContainerView(){
        
        containerView.backgroundColor = .white.withAlphaComponent(0)
        containerView.isPagingEnabled = false
        containerView.showsVerticalScrollIndicator = false
        containerView.delegate = self
        
    }
    
    private func setupBinderGetData(){
        viewModel.transform(input: event.eraseToAnyPublisher())
            .receive(on: DispatchQueue.main)
            .sink {[weak self] output in
                switch output{
                case .fetchDataDidFail:
                    print("neeed to prelace view")
                case .fetchSuccesHourlyForecastItem(forecastData: let forecastData):
                    self!.hourlyForecastView.hourlyForcastItems = forecastData
                case .fetchSuccessTendayForecastItem(forecastData: let forecastData):
                    self!.tenDayForecastView.tenDayForcastItems = forecastData
                case .fetchSuccessForecastItem(forecastData: let forecastData):
                    forecastData.forEach { forecastItem in
                        let titleCardView = forecastItem.title
                        let iconCardView = forecastItem.icon
                        let forecastView =  ForecastView(frame: CGRect(x: 0, y: 0, width: (self!.frame.width * 45/100) - 5.HAdapted  , height: self!.frame.width * 45/100))
                        forecastView.config(item: forecastItem)
                        
                        if forecastItem.typeForecast == .uv{
                            self!.uvBar.frame = CGRect(x: 0, y: 0, width: 0, height: 5.VAdapted)
                            forecastView.configDescriptionView(view: self!.uvBar)
                        }
                        
                        let cardViewItem = CardViewItem(title: titleCardView, icon: iconCardView, content: forecastView, widthSeparator: 0, titleColor: .white, iconColor: .white, heightHeader: Int(40.VAdapted))
                        self!.cardViewItems.append(cardViewItem)
                    }
                case .fetchSuccessHeaderWeatherItem(headerWeather: let headerWeather):
                    self!.headerContent.config(item: headerWeather)
                    
                case .fetchDataFinished:
                    //                    layout cardView when set lstCardViewItem
                    self!.bodyContent.lstCardViewItem = self!.cardViewItems
                    self!.heightBodyContent = self!.bodyContent.heightContent + CGFloat(self!.bodyContent.lstCardViewItem.count) * self!.bodyContent.spacingItem
                    self!.containerView.contentSize = CGSize(width: self!.frame.width, height: self!.heightBodyContent + heightHeaderContent)
                case .fetchSuccessUVBar(uvBarItem: let uvBarItem):
                    self!.uvBar.config(tempBarItem: uvBarItem, widthTempBar: (self!.frame.width * 45/100) - 25.HAdapted )
                }
            }.store(in: &cancellables)
    
    }
   
    private func setupBinderChangeView(){
        viewModel.bodyContentState.sink { [weak self] (state, offsetDidScroll) in
            switch state{
            case .refreshHeaderSubview:
                self!.bodyContent.refreshHeaderSubview()
            case .viewDidScroll:
                self!.bodyContent.viewDidScroll(with: self!.containerView, and: offsetDidScroll)
            }
        }.store(in: &cancellables)
        
        viewModel.heightHeader.sink { [weak self] height in
            self!.heightHeaderContentConstraint?.update(offset: height)
        }.store(in: &cancellables)
        
        
        viewModel.changeLblHeader.sink {[weak self] (value, offSet) in
            if value{
                self!.headerContent.changeDisLblAndTopHeaderDidScroll(contentOffset: offSet)
                self!.headerContent.changeColorLbl(contentOffSet: offSet)
            }
        }.store(in: &cancellables)
        
       
    }
    
    private func setupHourlyForecastTenDayForecastView(){
        
        
        let cardView1 = CardViewItem(title: "HOURLY FORECAST", icon: UIImage(systemName: "timer"), content: hourlyForecastView, widthSeparator: 400.HAdapted, titleColor: .white, iconColor: .white, heightHeader: Int(40.VAdapted))
        
        let cardView2 = CardViewItem(title: "10-DAY FORECAST", icon: UIImage(systemName: "calendar"), content: tenDayForecastView, widthSeparator: 0, titleColor: .white, iconColor: .white, heightHeader: Int(40.VAdapted))
      
       
        
        cardViewItems.append(cardView1)
        cardViewItems.append(cardView2)
        
    }
 
    private func constraint(){
        
        addSubview(containerView)
        
        containerView.snp.makeConstraints {make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        containerView.addSubview(headerContent)
        containerView.addSubview(bodyContent)
        
        headerContent.snp.makeConstraints { [weak self] make in
            make.top.equalTo(self!.snp.topMargin)
            make.left.equalTo(self!.snp.left)
            make.right.equalTo(self!.snp.right)
            self!.heightHeaderContentConstraint =  make.height.equalTo(heightHeaderContent).constraint
        }
        
        bodyContent.snp.makeConstraints { [weak self] make in
            make.top.equalTo(self!.headerContent.snp.bottom).offset(5.VAdapted)
            make.width.equalTo(self!.frame.width * 90/100)
            make.bottom.equalTo(self!.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
}

extension ContentView: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        viewModel.scrollAction(with: contentOffset, bodyContentOffsetIsZero: bodyContent.checkContentOffSetIsZero())
            
    }
    
}


