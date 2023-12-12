//
//  WeatherViewCell.swift
//  Weather
//
//  Created by Long Tran on 07/11/2023.
//

import UIKit
import SnapKit
import Combine


class WeatherViewCell: UITableViewCell {

    static let identifier = "WeatherViewCell"
    
    private lazy var titleLbl = UILabel(frame: .zero)
    private lazy var subtileLbl = UILabel(frame: .zero)
    private lazy var conditionLbl = UILabel(frame: .zero)
    private lazy var degreeLbl = UILabel(frame: .zero)
    private lazy var highLowDegreeLbl = UILabel(frame: .zero)
    private  lazy var backgroundImgView = UIImageView(frame: .zero)
    private  var heightConstraint : Constraint?
    private var backgroundImg: UIImage?
    
    private let font1 = AdaptiveFont.bold(size: 20.HAdapted)
    private let font2 = AdaptiveFont.bold(size: 15.HAdapted)
    private let font3 = AdaptiveFont.medium(size: 40.HAdapted)
    private let lblColor: UIColor = .white
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 15.HAdapted
        clipsToBounds = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constraint()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBackgroundClear( is isClear: Bool){
//        self.backgroundImg.alpha = alpha
        if isClear{
            self.backgroundImgView.image = nil
            self.backgroundImgView.backgroundColor = .clear
        }
        
    }
    
    func refreshBackground(){
        self.backgroundImgView.image = backgroundImg
        
    }
    
    func config(item: WeatherItem){
        titleLbl.text = item.location
        subtileLbl.text = item.time
        highLowDegreeLbl.text = "H:\(item.highDegree)° L:\(item.lowDegree)°"
        conditionLbl.text = item.condtion
        degreeLbl.text = item.currentDegree 
        backgroundImgView.image = item.background
        self.backgroundImg = item.background
    }
    
    
    private func layout(){
//        showingDeleteConfirmation = true
        contentView.preservesSuperviewLayoutMargins = true
        layer.cornerRadius = 20.HAdapted
        layer.masksToBounds = true
        clipsToBounds = true
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.layer.cornerRadius = 15.HAdapted
        contentView.clipsToBounds = true
        contentView.backgroundColor = .clear
        
//        font
        titleLbl.font = font1
        subtileLbl.font = font2
        conditionLbl.font = font2
        degreeLbl.font = font3
        highLowDegreeLbl.font = font2
        
//        color
        titleLbl.textColor = lblColor
        subtileLbl.textColor = lblColor
        conditionLbl.textColor = lblColor
        degreeLbl.textColor = lblColor
        highLowDegreeLbl.textColor = lblColor
        
//        backgroundImg
        
        backgroundImgView.contentMode = .scaleAspectFill
        backgroundImgView.clipsToBounds = true
        backgroundImgView.layer.cornerRadius = 20.HAdapted
        backgroundImgView.backgroundColor = .red
        
//        delete Btn
  
    }
    
    func makeConditionLblHighLowDegreeLblHidden(is hidden: Bool){
        conditionLbl.isHidden = hidden
        highLowDegreeLbl.isHidden = hidden
    }

    
    private func constraint(){
        contentView.addSubview(backgroundImgView)
        backgroundImgView.addSubview(titleLbl)
        backgroundImgView.addSubview(subtileLbl)
        backgroundImgView.addSubview(conditionLbl)
        backgroundImgView.addSubview(degreeLbl)
        backgroundImgView.addSubview(highLowDegreeLbl)
        
        backgroundImgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(5.HAdapted)
            make.right.equalToSuperview().offset(-5.HAdapted)
            make.bottom.equalToSuperview().offset(-15)
        }
          
        titleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15.VAdapted)
            make.left.equalToSuperview().offset(15.HAdapted)
        }
        
        subtileLbl.snp.makeConstraints {[weak self] make in
            make.top.equalTo(self!.titleLbl.snp.bottom).offset(5.VAdapted)
            make.left.equalToSuperview().offset(15)
        }
        
        conditionLbl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-15.VAdapted)
            make.left.equalToSuperview().offset(15.HAdapted)
        }
        
        degreeLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15.VAdapted)
            make.right.equalToSuperview().offset(-15.HAdapted)
        }
        
        highLowDegreeLbl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-15.VAdapted)
            make.right.equalToSuperview().offset(-20.HAdapted)
        }
//        
        
    }
    
}
