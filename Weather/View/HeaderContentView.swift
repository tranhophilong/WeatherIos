//
//  HeaderContentView.swift
//  Weather
//
//  Created by Long Tran on 28/10/2023.
//

import UIKit
import SnapKit
import Combine


class HeaderContentView: UIView{
    
    private lazy var locationLbl = FittableFontLabel(frame: .zero)
    private lazy var degreeLbl = FittableFontLabel(frame: .zero)
    private lazy var conditionWeatherLbl = FittableFontLabel(frame: .zero)
    private lazy var hightLowDegreeLbl = FittableFontLabel(frame: .zero)
    private lazy var degreeIcon = FittableFontLabel(frame: .zero)
    private lazy var  degreeConditionLbl = FittableFontLabel(frame: .zero)
    private let viewModel = HeaderContentViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let lblColor: UIColor = .white
    
    
    private var locationLblToTopHeaderConstraint: Constraint?
        
    private let fontDegreeLbl = UIFont.systemFont(ofSize: round(heightHeaderContent * 0.27), weight: .thin)
    private let fontConditionLbl = UIFont.systemFont(ofSize: round(heightHeaderContent * 0.054), weight: .bold)
    private let fontLocationLbl = UIFont.systemFont(ofSize: round(heightHeaderContent * 0.108), weight: .regular)
    
   

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        constraint()
        setupBinder()
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
        locationLbl.textColor = lblColor
        degreeLbl.textColor = lblColor
        conditionWeatherLbl.textColor = lblColor
        hightLowDegreeLbl.textColor = lblColor
        degreeConditionLbl.textColor = lblColor
        
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
    
    private func setupBinder(){
        viewModel.alphaColorhightLowDegreeLbl.sink {[weak self] alpha in
            self!.hightLowDegreeLbl.textColor = self!.lblColor.withAlphaComponent(alpha)
        }.store(in: &cancellables)
        
        viewModel.alphaColorConditionWeatherLbl.sink {[weak self] alpha in
            self!.conditionWeatherLbl.textColor = self!.lblColor.withAlphaComponent(alpha)
        }.store(in: &cancellables)
        
        viewModel.alphaColorDegreeConditionLbl.sink { [weak self] alpha in
            self!.degreeConditionLbl.textColor = self!.lblColor.withAlphaComponent(alpha)
        }.store(in: &cancellables)
        
        viewModel.alphaColorDegreeLbl.sink {[weak self] alpha in
            self!.degreeLbl.textColor = self!.lblColor.withAlphaComponent(alpha)
            self!.degreeIcon.textColor = self!.lblColor.withAlphaComponent(alpha)
        }.store(in: &cancellables)
        
        viewModel.disLocationLblAndTopHeader.sink {[weak self] dis in
            self!.locationLblToTopHeaderConstraint?.update(offset: dis)
        }.store(in: &cancellables)
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
            locationLblToTopHeaderConstraint =  make.top.equalToSuperview().offset(disLocationLblAndTopHeaderStart ).constraint
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
            make.top.equalTo(locationLbl.snp.bottom).offset( didsDegreeLblAndLocationLbl)
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
    func changeDisLblAndTopHeaderDidScroll(contentOffset: CGFloat){
        viewModel.changeDisLblAndTopHeaderDidScroll(with: contentOffset)
    }
    
    func changeColorLbl(contentOffSet: CGFloat){
        
        viewModel.changeColorLbl(with: contentOffSet)
    }
    
   
}
