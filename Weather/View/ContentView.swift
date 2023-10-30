//
//  ContentView.swift
//  Weather
//
//  Created by Long Tran on 22/10/2023.
//

import UIKit
import SnapKit

class ContentView: UIView{
    
    private lazy var containerView = UIScrollView(frame: .zero)
    private lazy var headerContent = HeaderContentView(frame: .zero)
    private lazy var bodyContent = BodyContentView(frame: .zero)
    private var heightHeaderContentConstraint: Constraint?
    let title : String
    
    
    public init(frame: CGRect, title: String) {
        self.title = title
        super.init(frame: frame)
        
        setupContainerView()
        constraint()
        setupBody()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContainerView(){
        
        containerView.backgroundColor = .white.withAlphaComponent(0)
        containerView.isPagingEnabled = false
        containerView.showsVerticalScrollIndicator = false
        containerView.contentSize = CGSize(width: self.frame.width, height: self.frame.height + heightHeaderContent)
        containerView.delegate = self
        
    }
    
    private func setupHeader(){
        
    }
    
    private func setupBody(){
        
        
        let cardView1 = CardViewItem(title: "Hourly Forecast", icon: UIImage(systemName: "timer"), content: ViewForCardView(frame: CGRect(x: 0, y: 0, width: self.frame.width * 90/100 , height: 150.VAdapted)), widthSeparator: 400.HAdapted, titleColor: .white, iconColor: .white, heightHeader: Int(50.VAdapted))
        
        let cardView2 = CardViewItem(title: "Ten day Forecast", icon: UIImage(systemName: "calendar.circle.fill"), content: ViewForCardView(frame: CGRect(x: 0, y: 0, width: self.frame.width * 90/100 , height: 350.VAdapted)), widthSeparator: 400.HAdapted, titleColor: .white, iconColor: .white, heightHeader: Int(50.VAdapted))
        
        let lstCardViewItem: [CardViewItem] = [cardView1, cardView2]
        
        bodyContent.lstCardViewItem = lstCardViewItem
        
        
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
            make.height.equalTo(self!.frame.height)
            make.centerX.equalToSuperview()
        }
        
        
    }
}

extension ContentView: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//            minis margin top of Screen
        let contentOffSet = -scrollView.contentOffset.y - STATUS_BAR_HEIGHT()
        if (CGFloat(heightHeaderContent) + contentOffSet - 10.VAdapted >= CGFloat(74.VAdapted) ){
            heightHeaderContentConstraint?.update(offset: heightHeaderContent + contentOffSet)
            headerContent.changeDisLblAndTopHeaderDidScroll(scrollView: scrollView)
            headerContent.hiddenLabelDidScroll(scrollView: scrollView)
        }
      
    }
}


