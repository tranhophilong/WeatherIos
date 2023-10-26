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
    private lazy var lbl = UILabel(frame: .zero)
    private lazy var cardView = CardView(frame: .zero)
    private lazy var headerContent = HeaderContentView(frame: .zero)
    private var heightHeaderContentConstraint: Constraint?
    private let heightHeaderContent: Int = 320
    let title : String
    
    
    public init(frame: CGRect, title: String) {
        self.title = title
        super.init(frame: frame)
        
        setupContainerView()
        setupSubViews()
        constraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    private func setupSubViews(){
        cardView.setTitle(title: "Weather")
        cardView.setWidthSeparator(width: SCREEN_WIDTH())
        cardView.setTitleColor(color: .white)
        cardView.setIconColor(color: .white)
        cardView.setHeighHeader(height: 50)
        cardView.setIcon(icon: UIImage(systemName: "figure.stand.line.dotted.figure.stand"))
//        cardView.remakeContrainTopHeader(to: self)
        
    }
    
    private func setupContainerView(){
        
        containerView.backgroundColor = .white.withAlphaComponent(0)
        containerView.isPagingEnabled = false
        containerView.showsVerticalScrollIndicator = false
        containerView.contentSize = CGSize(width: self.frame.width, height: self.frame.height * 3)
        containerView.delegate = self
    }
    
    private func constraint(){
        
        addSubview(containerView)
        
        
        
        
        
        containerView.snp.makeConstraints {[weak self] make in
            make.top.equalTo(self!.snp_topMargin)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        containerView.addSubview(headerContent)
        
        headerContent.snp.makeConstraints { [weak self] make in
            make.top.equalTo(self!.snp_topMargin).offset(10)
            make.left.equalTo(self!.snp.left)
            make.right.equalTo(self!.snp.right)
            heightHeaderContentConstraint =  make.height.equalTo(heightHeaderContent.VAdapted).constraint
        }
        
        
        containerView.addSubview(cardView)
        
        cardView.snp.makeConstraints { make in
            make.top.equalTo(headerContent.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(350.VAdapted)
            
        }
        
        
    }
}

extension ContentView: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var contentOffSet = -scrollView.contentOffset.y
        print(scrollView.contentOffset.y)
        heightHeaderContentConstraint?.update(offset: heightHeaderContent + Int(contentOffSet))
        headerContent.scrollViewDidScroll(scrollView: scrollView)
    }
}


class HeaderContentView: UIView{
    private lazy var locationLbl = UILabel(frame: .zero)
    private lazy var degreeLbl = UILabel(frame: .zero)
    private lazy var conditionWeatherLbl = UILabel(frame: .zero)
    private lazy var hightLowDegreeLbl = UILabel(frame: .zero)
    
    private var locationLblToTopHeaderConstraint: Constraint?
    
    private var disHightLowDegreeLblAndBottomHeader: CGFloat?
    private var disConditionWeatherLblAndBottomHeader: CGFloat?
    private var disDegreeLblAndBottomHeader: CGFloat?
    
    private let disConditionLblAndDegreeLbl: CGFloat = 5.VAdapted
    private let disHightLowDegreeLblAndConditionWeatherLbl: CGFloat = 10.VAdapted
    private let disLocationLblAndTopHeader: CGFloat = 35.VAdapted
    private let didsDegreeLblAndLocationLbl: CGFloat = 5.VAdapted
    
    private let fontDegreeLbl = AdaptiveFont.thin(size: 95)
    private let fontConditionLbl = AdaptiveFont.bold(size: 20)
    private let fontLocationLbl = AdaptiveFont.medium(size: 30)
     
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        constraint()
        disDegreeLblAndBottomHeader =  320 - disLocationLblAndTopHeader - String.textSize(locationLbl.text, withFont: fontLocationLbl).height - didsDegreeLblAndLocationLbl -
                                    String.textSize(degreeLbl.text, withFont: fontDegreeLbl).height
        disConditionWeatherLblAndBottomHeader = disDegreeLblAndBottomHeader! - disConditionLblAndDegreeLbl - String.textSize(conditionWeatherLbl.text, withFont: fontConditionLbl).height
        disHightLowDegreeLblAndBottomHeader = disConditionWeatherLblAndBottomHeader! - disHightLowDegreeLblAndConditionWeatherLbl - String.textSize(hightLowDegreeLbl.text, withFont: fontConditionLbl).height
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
//        backgroundColor = .green
//        degreeLbl.backgroundColor = UIColor.red
        locationLbl.font = fontLocationLbl
        degreeLbl.font = fontDegreeLbl
        conditionWeatherLbl.font = fontConditionLbl
        hightLowDegreeLbl.font = fontConditionLbl
        
        locationLbl.textColor = .white
        degreeLbl.textColor = .white
        conditionWeatherLbl.textColor = .white
        hightLowDegreeLbl.textColor = .white
        
        locationLbl.text = "Ho Chi Minh City"
        degreeLbl.text = "29°"
        conditionWeatherLbl.text = "Partly Cloudy"
        hightLowDegreeLbl.text = "H:32° L:24°"
        
        conditionWeatherLbl.textAlignment = .left
    }
    
    private func constraint(){
        
        addSubview(locationLbl)
        addSubview(degreeLbl)
        addSubview(conditionWeatherLbl)
        addSubview(hightLowDegreeLbl)
        
        
        
        locationLbl.snp.makeConstraints { make in
            make.centerX.equalTo(degreeLbl)
            locationLblToTopHeaderConstraint =  make.top.equalToSuperview().offset(disLocationLblAndTopHeader).constraint
            
        }
        
        degreeLbl.snp.makeConstraints { make in
            make.top.equalTo(locationLbl.snp.bottom).offset(didsDegreeLblAndLocationLbl)
            make.centerX.equalToSuperview()
        }
        
        conditionWeatherLbl.snp.makeConstraints { make in
            make.top.equalTo(degreeLbl.snp.bottom).offset(disConditionLblAndDegreeLbl)
            make.centerX.equalTo(degreeLbl)
        }
        
        hightLowDegreeLbl.snp.makeConstraints { make in
            make.centerX.equalTo(degreeLbl)
            make.top.equalTo(conditionWeatherLbl.snp.bottom).offset(disHightLowDegreeLblAndConditionWeatherLbl)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView){
        var contentOffSet = -scrollView.contentOffset.y
        locationLblToTopHeaderConstraint?.update(offset: disLocationLblAndTopHeader + contentOffSet * 1/4)
    }
}
