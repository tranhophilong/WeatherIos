//
//  ForecastView.swift
//  Weather
//
//  Created by Long Tran on 05/11/2023.
//

import UIKit
import SnapKit

class ForecastView: ViewForCardView {
    
   
    private lazy var  indexLbl = UILabel(frame: .zero)
    private lazy var  descriptionLbl = UILabel(frame: .zero)
    private lazy  var descriptionView = UIView(frame: .zero)
    private lazy var subDescription = UILabel(frame: .zero)
    
    
    private let indexLblFont = AdaptiveFont.bold(size: 25.HAdapted)
    private let desLblFont = AdaptiveFont.bold(size: 17.HAdapted)
    private let subDesFont = AdaptiveFont.medium(size: 15.HAdapted)
    
    private let lblColor: UIColor = .white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        constraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(item: ForecastItem){
        indexLbl.text = item.index
        descriptionLbl.text = item.description
        subDescription.text =  item.subdescription
    }
    
    private func layout(){

        backgroundColor = .clear
 
        
//        font
        indexLbl.font = indexLblFont
        descriptionLbl.font = desLblFont
        subDescription.font = subDesFont
        
//        text color
        indexLbl.textColor = lblColor
        descriptionLbl.textColor = lblColor
        subDescription.textColor = lblColor
        
        
//       align text
        indexLbl.textAlignment = .left
        descriptionLbl.textAlignment = .left
        subDescription.textAlignment = .left
        
        
//        subDesLbl
        subDescription.numberOfLines = 0
        subDescription.lineBreakMode = .byWordWrapping
        
        
//        descriptionView
        descriptionView.backgroundColor = .clear
        
        

    }
    
    func configDescriptionView(view: UIView){
        print(view.frame)
        descriptionView.addSubview(view)
    }
    
    private func constraint(){
//        addSubview(stackViewVer)
        addSubview(indexLbl)
        addSubview(descriptionLbl)
        addSubview(subDescription)
        addSubview(descriptionView)

        indexLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.VAdapted)
            make.left.equalToSuperview().offset(10.HAdapted)
        }
        
        descriptionLbl.snp.makeConstraints {[weak self] make in
            make.top.equalTo(self!.indexLbl.snp.bottom).offset(5.VAdapted)
            make.left.equalToSuperview().offset(10.HAdapted)
        }
        
        descriptionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10.HAdapted)
            make.right.equalToSuperview().offset(-15.HAdapted)
            make.top.equalTo(descriptionLbl.snp.bottom).offset(10.VAdapted)
            make.bottom.equalTo(subDescription.snp.top)
        }
        
        subDescription.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10.VAdapted)
            make.left.equalToSuperview().offset(10.HAdapted)
        }

    }
    
}
