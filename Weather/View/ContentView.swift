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
    private var heightHeaderContentConstraint: Constraint?
    private var heightBodyContent: CGFloat = 0
    private var contentOffSetDidScroll: CGFloat = 0
    private var didGetContentOffSetDidScroll: Bool = false
    let title : String
    private let viewModel = ContentViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    
    public init(frame: CGRect, title: String) {
        self.title = title
        super.init(frame: frame)
        setupBody()
        setupContainerView()
        constraint()
        setupBinder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContainerView(){
        
        containerView.backgroundColor = .white.withAlphaComponent(0)
        containerView.isPagingEnabled = false
        containerView.showsVerticalScrollIndicator = false
        containerView.contentSize = CGSize(width: self.frame.width, height: heightBodyContent + heightHeaderContent)
        containerView.delegate = self
        
    }
    
    private func setupHeader(){
        
    }
    
    private func setupBinder(){
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
    
    private func setupBody(){
        
        
        let cardView1 = CardViewItem(title: "Hourly Forecast", icon: UIImage(systemName: "timer"), content: ViewForCardView(frame: CGRect(x: 0, y: 0, width: self.frame.width * 95/100 , height: 150.VAdapted)), widthSeparator: 400.HAdapted, titleColor: .white, iconColor: .white, heightHeader: Int(50.VAdapted))
        
        let cardView2 = CardViewItem(title: "Ten day Forecast", icon: UIImage(systemName: "calendar.circle.fill"), content: ViewForCardView(frame: CGRect(x: 0, y: 0, width: self.frame.width * 95/100 , height: 350.VAdapted)), widthSeparator: 400.HAdapted, titleColor: .white, iconColor: .white, heightHeader: Int(50.VAdapted))
        
        let cardView3 = CardViewItem(title: "Forecast", icon: UIImage(systemName: "exclamationmark.triangle"), content: ViewForCardView(frame: CGRect(x: 0, y: 0, width: self.frame.width * 95/100 , height: 350.VAdapted)), widthSeparator: 400.HAdapted, titleColor: .white, iconColor: .white, heightHeader: Int(50.VAdapted))
        
        
        let cardView4 = CardViewItem(title: "Forecast333", icon: UIImage(systemName: "exclamationmark.triangle"), content: ViewForCardView(frame: CGRect(x: 0, y: 0, width: self.frame.width * 95/100 , height: 350.VAdapted)), widthSeparator: 400.HAdapted, titleColor: .white, iconColor: .white, heightHeader: Int(50.VAdapted))

        
        let lstCardViewItem: [CardViewItem] = [cardView1, cardView2, cardView3, cardView4]
        
        bodyContent.lstCardViewItem = lstCardViewItem
        bodyContent.clipsToBounds = true
        bodyContent.layer.cornerRadius = 20.HAdapted
        heightBodyContent = bodyContent.heightContent + CGFloat(bodyContent.lstCardViewItem.count) * bodyContent.spacingItem
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
            make.width.equalTo(self!.frame.width * 95/100)
//            make.height.equalTo(self!.frame.height)
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


