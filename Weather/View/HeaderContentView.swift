//
//  HeaderContentView.swift
//  Weather
//
//  Created by Long Tran on 28/10/2023.
//

import UIKit
import SnapKit

class HeaderContentView: UIView{
    
    private lazy var locationLbl = FittableFontLabel(frame: .zero)
    private lazy var degreeLbl = FittableFontLabel(frame: .zero)
    private lazy var conditionWeatherLbl = FittableFontLabel(frame: .zero)
    private lazy var hightLowDegreeLbl = FittableFontLabel(frame: .zero)
    private lazy var degreeIcon = FittableFontLabel(frame: .zero)
    private lazy var  degreeConditionLbl = FittableFontLabel(frame: .zero)
    
    private var locationLblToTopHeaderConstraint: Constraint?
    
    private let disConditionLblAndDegreeLbl: CGFloat = round(heightHeaderContent * 0.027)
    private let disHightLowDegreeLblAndConditionWeatherLbl: CGFloat = round(heightHeaderContent * 0.027)
    private let didsDegreeLblAndLocationLbl: CGFloat = round(heightHeaderContent * 0.027)
    
    private let disLocationLblAndTopHeader: CGFloat = heightHeaderContent/5
    private let disDegreeLblAndBottomHeader: CGFloat = heightHeaderContent * 2/5
    private let disConditionWeatherLblAndBottomHeader: CGFloat = round(heightHeaderContent * 0.3)
    private let disDegreeConditionAndBottomHeader: CGFloat = round(heightHeaderContent * 0.627)
    private let disHightLowDegreeLblAndBottomHeader: CGFloat = heightHeaderContent/5
    
    private let heightHightAndLowDegreeLbl: CGFloat = round(heightHeaderContent * 0.073)
    private let heightConditionLbl: CGFloat = round(heightHeaderContent * 0.073)
    private let heightDegreeLbl: CGFloat = heightHeaderContent/5
    
        
    private let fontDegreeLbl = UIFont.systemFont(ofSize: round(heightHeaderContent * 0.27), weight: .thin)
    private let fontConditionLbl = UIFont.systemFont(ofSize: round(heightHeaderContent * 0.054), weight: .bold)
    private let fontLocationLbl = UIFont.systemFont(ofSize: round(heightHeaderContent * 0.108), weight: .regular)
    
   

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        constraint()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        
//        font
        degreeLbl.font = fontDegreeLbl
        conditionWeatherLbl.font = fontConditionLbl
        hightLowDegreeLbl.font = fontConditionLbl
        degreeConditionLbl.font = fontConditionLbl
        locationLbl.font = fontLocationLbl
        
//      color
        locationLbl.textColor = .white
        degreeLbl.textColor = .white
        conditionWeatherLbl.textColor = .white
        hightLowDegreeLbl.textColor = .white
        degreeConditionLbl.textColor = .white.withAlphaComponent(0)
        
//        setText
        locationLbl.text = "Ho Chi Minh City"
        degreeLbl.text = "33"
        conditionWeatherLbl.text = "Mostly Cloudy"
        hightLowDegreeLbl.text = "H:33° L:24°"
        degreeConditionLbl.text = "33° | Cloudy"
        
       
//        config Attribute
        degreeLbl.autoAdjustFontSize = true
        degreeLbl.lineBreakMode = .byWordWrapping
        degreeLbl.topInset = 0
        degreeLbl.bottomInset = 0
        
        
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
       
        
        degreeConditionLbl.autoAdjustFontSize = true
        degreeConditionLbl.lineBreakMode = .byWordWrapping
        degreeConditionLbl.topInset = 0
        degreeConditionLbl.bottomInset = 0

        
//        Degree Icon
        degreeIcon.text = "°"
        degreeIcon.textColor  = .white
        degreeIcon.font = fontDegreeLbl
    }
    
    private func constraint(){
        
        addSubview(locationLbl)
        addSubview(degreeLbl)
        addSubview(conditionWeatherLbl)
        addSubview(hightLowDegreeLbl)
        addSubview(degreeIcon)
        addSubview(degreeConditionLbl)
        
        
        locationLbl.snp.makeConstraints { make in
            make.centerX.equalTo(degreeLbl)
            locationLblToTopHeaderConstraint =  make.top.equalToSuperview().offset(disLocationLblAndTopHeader ).constraint
            make.height.equalTo(round(heightHeaderContent * 0.173))
            
            make.width.equalTo(String.textSize(locationLbl.text, withFont: fontLocationLbl).width.adaptedFontSize)
                
        }
        
        degreeConditionLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(String.textSize(degreeConditionLbl.text, withFont: fontConditionLbl).width.adaptedFontSize)
            make.height.equalTo(round(heightHeaderContent * 0.073))
            make.top.equalTo(locationLbl.snp.bottom).offset(5.VAdapted)
        }
        
        degreeLbl.snp.makeConstraints { make in
            make.top.equalTo(locationLbl.snp.bottom).offset(didsDegreeLblAndLocationLbl)
            make.centerX.equalToSuperview()
            make.height.equalTo(heightDegreeLbl)
            make.width.equalTo(String.textSize(degreeLbl.text, withFont: fontDegreeLbl).width.adaptedFontSize)
        }
        
        degreeIcon.snp.makeConstraints { make in
            make.centerY.firstBaseline.equalTo(degreeLbl)
            make.left.equalTo(degreeLbl.snp.right).offset(5.HAdapted)
        }
        
        
        conditionWeatherLbl.snp.makeConstraints { make in
            make.top.equalTo(degreeLbl.snp.bottom).offset(disConditionLblAndDegreeLbl)
            make.centerX.equalTo(degreeLbl)
            make.height.equalTo(heightConditionLbl)
            make.width.equalTo(String.textSize(conditionWeatherLbl.text, withFont: fontConditionLbl).width.adaptedFontSize)
        }
        
        hightLowDegreeLbl.snp.makeConstraints { make in
            make.centerX.equalTo(degreeLbl)
            make.top.equalTo(conditionWeatherLbl.snp.bottom).offset(disHightLowDegreeLblAndConditionWeatherLbl)
            make.height.equalTo(heightHightAndLowDegreeLbl)
            make.width.equalTo(String.textSize(hightLowDegreeLbl.text, withFont: fontConditionLbl).width.adaptedFontSize)
        }
            }
   
}
//MARK: - Animation Scroll

extension HeaderContentView{
    func changeDisLblAndTopHeaderDidScroll(scrollView: UIScrollView){
        var contentOffSet = -scrollView.contentOffset.y - STATUS_BAR_HEIGHT()
        let offSet = contentOffSet * 1/3
        
        locationLblToTopHeaderConstraint?.update(offset: disLocationLblAndTopHeader + offSet)
        
    }
    
    func hiddenLabelDidScroll(scrollView: UIScrollView){

        let contentOffSet = -scrollView.contentOffset.y - STATUS_BAR_HEIGHT()
        
        let alpha1 =   ( disHightLowDegreeLblAndBottomHeader  + heightHightAndLowDegreeLbl + contentOffSet ) / (disHightLowDegreeLblAndBottomHeader / 2)
        
        hiddenLabel(lbl: hightLowDegreeLbl, with:  alpha1)
            
        let alpha2 = (disConditionWeatherLblAndBottomHeader + heightConditionLbl + contentOffSet) / (disConditionWeatherLblAndBottomHeader - disHightLowDegreeLblAndBottomHeader  )
        
        hiddenLabel(lbl: conditionWeatherLbl, with: alpha2)
        
        let alpha3 = (disDegreeLblAndBottomHeader  + heightConditionLbl + contentOffSet) / (disDegreeLblAndBottomHeader - disConditionWeatherLblAndBottomHeader  - heightConditionLbl)
        hiddenLabel(lbl: degreeLbl, with: alpha3)
        hiddenLabel(lbl: degreeIcon, with: alpha3)
        
        let alpha4 = (disDegreeConditionAndBottomHeader + contentOffSet) / (heightDegreeLbl / 2)
        showLabel(lbl: degreeConditionLbl, with: alpha4)
    }
    
    private func showLabel(lbl: UILabel, with alpha: CGFloat){
        lbl.textColor = .white.withAlphaComponent( 1 - alpha)
    }
    
    private func hiddenLabel(lbl : UILabel, with alpha: CGFloat){
        lbl.textColor = .white.withAlphaComponent(alpha)
    }
}