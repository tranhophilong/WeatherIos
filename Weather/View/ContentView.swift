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
    private let heightHeaderContent: Int = Int(370.VAdapted)
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
        
//        containerView.backgroundColor = .brown
    }
    
    private func constraint(){
        
        addSubview(containerView)
        
        
        containerView.snp.makeConstraints {[weak self] make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        containerView.addSubview(headerContent)
        
        headerContent.snp.makeConstraints { [weak self] make in
            make.top.equalTo(self!.snp_topMargin)
            make.left.equalTo(self!.snp.left)
            make.right.equalTo(self!.snp.right)
            heightHeaderContentConstraint =  make.height.equalTo(heightHeaderContent.VAdapted).constraint
        }
        
//        headerContent.backgroundColor = .gray
        
        containerView.addSubview(cardView)
        
        cardView.snp.makeConstraints { make in
            make.top.equalTo(headerContent.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(350.VAdapted)
            
        }
//        
        
    }
}

extension ContentView: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var contentOffSet = -scrollView.contentOffset.y - 44.VAdapted
        heightHeaderContentConstraint?.update(offset: heightHeaderContent + Int(contentOffSet))
        headerContent.scrollViewDidScroll(scrollView: scrollView)
    }
}


class HeaderContentView: UIView{
    private lazy var locationLbl = FittableFontLabel(frame: .zero)
    private lazy var degreeLbl = FittableFontLabel(frame: .zero)
    private lazy var conditionWeatherLbl = FittableFontLabel(frame: .zero)
    private lazy var hightLowDegreeLbl = FittableFontLabel(frame: .zero)
    private lazy var degreeIcon = FittableFontLabel(frame: .zero)
    
    private var locationLblToTopHeaderConstraint: Constraint?
    
    private var disHightLowDegreeLblAndBottomHeader: CGFloat?
    private var disConditionWeatherLblAndBottomHeader: CGFloat?
    private var disDegreeLblAndBottomHeader: CGFloat?
    
    private let disConditionLblAndDegreeLbl: CGFloat = 10.VAdapted
    private let disHightLowDegreeLblAndConditionWeatherLbl: CGFloat = 10.VAdapted
    private let disLocationLblAndTopHeader: CGFloat = 74.VAdapted
    private let didsDegreeLblAndLocationLbl: CGFloat = 10.VAdapted
    
    private let fontDegreeLbl = UIFont.systemFont(ofSize: 100.VAdapted, weight: .thin)
    private let fontConditionLbl = UIFont.systemFont(ofSize: 20.VAdapted, weight: .bold)
    private let fontLocationLbl = UIFont.systemFont(ofSize: 40.VAdapted, weight: .regular)

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        constraint()

        
       
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        
        
        
        degreeLbl.font = fontDegreeLbl
        conditionWeatherLbl.font = fontConditionLbl
        hightLowDegreeLbl.font = fontConditionLbl
//        
        locationLbl.textColor = .white
        degreeLbl.textColor = .white
        conditionWeatherLbl.textColor = .white
        hightLowDegreeLbl.textColor = .white
        
        locationLbl.text = "Ho Chi Minh City"
        degreeLbl.text = "33"
        conditionWeatherLbl.text = "Mostly Cloudy"
        hightLowDegreeLbl.text = "H:33° L:24°"
        
        
        
        degreeIcon.text = "°"
        degreeIcon.textColor  = .white
        degreeIcon.font = fontDegreeLbl
        
        degreeLbl.autoAdjustFontSize = true
        degreeLbl.lineBreakMode = .byWordWrapping
        degreeLbl.topInset = 0
        degreeLbl.bottomInset = 0
//        degreeLbl.backgroundColor = .red
        
        locationLbl.autoAdjustFontSize = true
        locationLbl.lineBreakMode = .byWordWrapping
        locationLbl.topInset = 0
        locationLbl.bottomInset = 0
        
    
        conditionWeatherLbl.autoAdjustFontSize = true
        conditionWeatherLbl.lineBreakMode = .byWordWrapping
        conditionWeatherLbl.topInset = 0
        conditionWeatherLbl.bottomInset = 0
        
        hightLowDegreeLbl.autoAdjustFontSize = true
        hightLowDegreeLbl.lineBreakMode = .byWordWrapping
        hightLowDegreeLbl.topInset = 0
        hightLowDegreeLbl.bottomInset = 0
        
    
    }
    
    private func constraint(){
        
        addSubview(locationLbl)
        addSubview(degreeLbl)
        addSubview(conditionWeatherLbl)
        addSubview(hightLowDegreeLbl)
        addSubview(degreeIcon)
        
        
        locationLbl.snp.makeConstraints { make in
            make.centerX.equalTo(degreeLbl)
            locationLblToTopHeaderConstraint =  make.top.equalToSuperview().offset(disLocationLblAndTopHeader ).constraint
            make.height.equalTo(54.VAdapted)
            
            make.width.equalTo(String.textSize(locationLbl.text, withFont: fontLocationLbl).width.adaptedFontSize)
                
        }
        
        degreeLbl.snp.makeConstraints { make in
            make.top.equalTo(locationLbl.snp.bottom).offset(didsDegreeLblAndLocationLbl)
            make.centerX.equalToSuperview()
            make.height.equalTo(74.VAdapted)
            make.width.equalTo(String.textSize(degreeLbl.text, withFont: fontDegreeLbl).width.adaptedFontSize)
        }
        
        degreeIcon.snp.makeConstraints { make in
            make.centerY.firstBaseline.equalTo(degreeLbl)
            make.left.equalTo(degreeLbl.snp.right).offset(5.VAdapted)
        }
        
        
        conditionWeatherLbl.snp.makeConstraints { make in
            make.top.equalTo(degreeLbl.snp.bottom).offset(disConditionLblAndDegreeLbl)
            make.centerX.equalTo(degreeLbl)
            make.height.equalTo(27.VAdapted)
            make.width.equalTo(String.textSize(conditionWeatherLbl.text, withFont: fontConditionLbl).width.adaptedFontSize)
        }
        
        hightLowDegreeLbl.snp.makeConstraints { make in
            make.centerX.equalTo(degreeLbl)
            make.top.equalTo(conditionWeatherLbl.snp.bottom).offset(disHightLowDegreeLblAndConditionWeatherLbl)
            make.height.equalTo(27.VAdapted)
            make.width.equalTo(String.textSize(hightLowDegreeLbl.text, withFont: fontConditionLbl).width.adaptedFontSize)
        }
        
        
              
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView){
        var contentOffSet = -scrollView.contentOffset.y - 44.VAdapted
        print(contentOffSet)
        locationLblToTopHeaderConstraint?.update(offset: disLocationLblAndTopHeader + contentOffSet * 1/3)
    }
}
