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
    private lazy var stackViewVer = UIStackView(frame: .zero)
    
    
    private let indexLblFont = AdaptiveFont.bold(size: 17.HAdapted)
    private let desLblFont = AdaptiveFont.bold(size: 17.HAdapted)
    private let subDesFont = AdaptiveFont.regular(size: 15.HAdapted)
    
    private let lblColor: UIColor = .white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        constraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        
        indexLbl.text = "8"
        descriptionLbl.text = "Low"
        subDescription.text = " Use sun protection 12:00 - 14:00"
        
        
        backgroundColor = .clear
//        stackViewVer
        stackViewVer.backgroundColor = .clear
        stackViewVer.axis = .vertical
        stackViewVer.distribution = .fillProportionally
        stackViewVer.alignment = .fill
        
        
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
        
        let stackVerHeader = UIStackView()
        stackVerHeader.axis = .vertical
        stackVerHeader.spacing = -10.VAdapted
        stackVerHeader.distribution = .fillProportionally
        
        stackVerHeader.addArrangedSubview(indexLbl)
        stackVerHeader.addArrangedSubview(descriptionLbl)
        
        
        
        stackViewVer.addArrangedSubview(stackVerHeader)
//        stackViewVer.addArrangedSubview(descriptionLbl)
//        stackViewVer.addArrangedSubview(descriptionView)
        stackViewVer.addArrangedSubview(subDescription)
        
        
//        subDescription.snp.makeConstraints { [weak self] make in
//            var height: CGFloat =  0
//            
//            for view in self!.stackViewVer.arrangedSubviews{
//                height =  self!.stackViewVer.frame.height -  view.frame.height
//            }
//            print(height)
//            make.height.equalTo(1.VAdapted)
//            make.width.equalTo(self!.frame.width)
            
//        }
//        descriptionView.backgroundColor = .orange
        
//        indexLbl.sizeToFit()

    }
    
    private func constraint(){
        addSubview(stackViewVer)
        stackViewVer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(10.HAdapted)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10.HAdapted)
        }
    }
    
}
