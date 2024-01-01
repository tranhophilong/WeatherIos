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
    private lazy var headerContent = HeaderContentView(frame: .zero, viewModel: headerContentViewModel)
    private lazy var bodyContent = BodyContentView(frame: .zero, viewModel: bodyContentViewModel)
    private let bodyContentViewModel = BodyContentViewModel()
    private let headerContentViewModel = HeaderContentViewModel()
    private var heightHeaderContentConstraint: Constraint?
    private let viewModel: ContentViewModel
    private let heightHeaderContent = 350.VAdapted
    private var cancellables = Set<AnyCancellable>()
    
    public init(frame: CGRect, viewModel: ContentViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupContainerView()
        constraint()
        setupBinderChangeView()
        setupBinderGetData()
        
        
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
        
        viewModel.fetchDataOutput
            .receive(on: DispatchQueue.main)
            .sink {[weak self] output in
            switch output{
                
            case .fetchDataDidFail:
                print("Fail")
            case .fetchDataFinished:
                print("finished")
            case .fetchSuccessDataHeader(forecastDayDetail: let forecastDayDetail, currentWeather: let currentWeather, locationWeather: let locationWeather):
                self?.headerContentViewModel.sendData(forecastDayDetail: forecastDayDetail, currentWeather: currentWeather, locationWeather: locationWeather)
            case .fechSuccessDataBodyContent(cardViewModelCreators: let cardViewModelCreators):
                self?.bodyContentViewModel.createCardViews(cardViewModelCreators: cardViewModelCreators)
                self?.containerView.contentSize.height = self!.bodyContentViewModel.contentSizeContainer.value.height + self!.heightHeaderContent
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
            self!.heightHeaderContentConstraint =  make.height.equalTo(350.VAdapted).constraint
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
        viewModel.scrollAction(with: contentOffset, bodyContentOffsetIsZero: bodyContent.checkContentOffSetIsZero(), heightHeaderContent: heightHeaderContent)
    }
 
}


