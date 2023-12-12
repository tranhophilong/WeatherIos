//
//  BarGradientColorView.swift
//  Weather
//
//  Created by Long Tran on 25/11/2023.
//

import UIKit
import SnapKit

class TempBarGradientColorView: UIView {
    
    private lazy var tempBarBackground = UIView(frame: .zero)
    private lazy var tempBar = CAGradientLayer()
    private lazy var pointCurrentDegree = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        constraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(tempBarItem: TempBarItem, widthTempBar: CGFloat){
        let colorGradientTempBars = tempBarItem.gradientColors.map { color in
            color.cgColor
        }
    
        self.tempBar.locations = tempBarItem.gradientLocations
        self.tempBar.colors = colorGradientTempBars
  
   
        let xTempBar = widthTempBar * tempBarItem.startPer
        let widthGradientColor = widthTempBar * tempBarItem.widthPer
        let xPointCurrentDegree = widthTempBar * tempBarItem.startPerPoint
        self.tempBar.frame = CGRect(x: xTempBar, y: 0, width: widthGradientColor, height: 5.VAdapted)
        
        let borderPointCurrentDegree = CALayer()
        borderPointCurrentDegree.backgroundColor =  UIColor.brightBlue.cgColor
        borderPointCurrentDegree.cornerRadius = 10.HAdapted/2
        
        pointCurrentDegree.frame = CGRect(x: xPointCurrentDegree, y: 0, width: 5.HAdapted, height: 5.VAdapted)
        borderPointCurrentDegree.frame = CGRect(x: 0, y: 0, width: 10.HAdapted, height: 10.VAdapted)
        borderPointCurrentDegree.position = CGPoint(x: pointCurrentDegree.frame.midX, y: pointCurrentDegree.frame.midY)
        tempBarBackground.layer.insertSublayer(tempBar, at: 0)
        
        if tempBarItem.isShowCurrentTemp{
            tempBarBackground.layer.insertSublayer(borderPointCurrentDegree, at: 1)
            tempBarBackground.layer.insertSublayer(pointCurrentDegree, at: 2)
        }
        
    }
    
    private func layout(){
        backgroundColor = .clear
        tempBarBackground.backgroundColor = .darkGray
        tempBarBackground.layer.cornerRadius =  5.HAdapted / 2
        
        tempBar.cornerRadius = 5.HAdapted/2
        tempBar.startPoint = CGPoint(x: 0, y: 0.5)
        tempBar.endPoint = CGPoint(x: 1, y: 0.5)
        
        pointCurrentDegree.backgroundColor = UIColor.white.cgColor
        pointCurrentDegree.cornerRadius = 5.HAdapted/2
        pointCurrentDegree.borderColor = UIColor.brightBlue.cgColor
    }
    
    private func constraint(){
        addSubview(tempBarBackground)
        tempBarBackground.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }

}
