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
    private lazy var headerContent = HeaderContentView(frame: .zero, viewModel: headerContentViewModel, heightHedaerContent: heightHeaderContent)
    private lazy var bodyContent = BodyContentView(frame: .zero, viewModel: bodyContentViewModel)
    private let bodyContentViewModel = BodyContentViewModel()
    private let headerContentViewModel = HeaderContentViewModel()
    private var heightHeaderContentConstraint: Constraint?
    unowned private let viewModel: ContentViewModel
    private let heightHeaderContent = 350.VAdapted
    private var cancellables = Set<AnyCancellable>()
    let event = PassthroughSubject<ContentViewModel.EventInput, Never>()
    
    public init(frame: CGRect, viewModel: ContentViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupContainerView()
        constraint()
        setupBinder()
        event.send(.viewDidLoad)
//        event.send(.scroll(contentOffSet: 0, bodyContentOffSetIsZero: false, heightHeaderContent: self.heightHeaderContent))
        
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
    
    private func setupBinder(){
        let outputEvent = viewModel.transform(input: event.eraseToAnyPublisher())
        outputEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
            switch event{
            case .fetchDataDidFail:
                print("Fail")
            case .fetchDataFinished:
                print("finished")
            case .fetchSuccessDataHeader(forecastDayDetail: let forecastDayDetail, currentWeather: let currentWeather, locationWeather: let locationWeather):
                self?.headerContentViewModel.sendData(forecastDayDetail: forecastDayDetail, currentWeather: currentWeather, locationWeather: locationWeather)
            case .fechSuccessDataBodyContent(cardViewModelCreators: let cardViewModelCreators):
                self?.bodyContentViewModel.createCardViews(cardViewModelCreators: cardViewModelCreators)
                self?.containerView.contentSize.height = self!.bodyContentViewModel.contentSizeContainer.value.height + self!.heightHeaderContent
            case .refreshBody(isRefresh: let isRefresh):
                if isRefresh{
                    self!.bodyContent.refreshHeaderSubview()
                }
            case .isHiddenEffectsLblHeader(isHiddenEffects: let isHiddenEffects, offset: let offset):
                if isHiddenEffects{
                    self!.headerContent.changeColorLbl(contentOffSet: offset)
                    self?.headerContent.changeDisLblAndTopHeaderDidScroll(contentOffset: offset)
                }
            case .isScrollToHeader(isScrollTo: let isScrollTo, offset: let offset):
                if isScrollTo{
                    self!.bodyContent.viewDidScroll(with: self!.containerView, and: offset)
                }
            case .changeHeightHeader(isChange: let isChange, height: let height):
                if isChange{
                    self!.heightHeaderContentConstraint?.update(offset: height)
                }else{
                    self!.heightHeaderContentConstraint?.update(offset: self!.heightHeaderContent/5 + 25.VAdapted)
                }

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
            self!.heightHeaderContentConstraint =  make.height.equalTo(self!.heightHeaderContent).constraint
        }
        
//        print(headerContent.frame.height)
        
        bodyContent.snp.makeConstraints { [weak self] make in
            make.top.equalTo(self!.headerContent.snp.bottom).offset(10.VAdapted)
            make.width.equalTo(SCREEN_WIDTH() * 90/100)
            make.bottom.equalTo(self!.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
}

extension ContentView: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        event.send(.scroll(contentOffSet: contentOffset, bodyContentOffSetIsZero: bodyContent.checkContentOffSetIsZero(), heightHeaderContent: heightHeaderContent))
    }
 
}


