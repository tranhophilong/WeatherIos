//
//  AlternativeView.swift
//  Weather
//
//  Created by Long Tran on 27/11/2023.
//

import UIKit
import SnapKit


class AlternativeView: UIView {
    
    private lazy var image = UIImageView(frame: .zero)
    private lazy var title = UILabel(frame: .zero)
    private lazy var subTitle = UILabel(frame: .zero)
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        constraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(img: UIImage?){
        image.image = img
    }
    
    func setTitle(text: String){
        title.text = text
    }
    
    func setSubTitle(text: String){
        subTitle.text = text
    }
    
    
    private func layout(){
        image.contentMode = .scaleAspectFill
        image.tintColor = .gray
        
        title.textColor = .white
        subTitle.textColor = .gray
        
        title.font = AdaptiveFont.bold(size: 20)
        subTitle.font = AdaptiveFont.medium(size: 16)
        
        title.textAlignment = .center
        
        subTitle.numberOfLines = 0
        subTitle.textAlignment = .center
        subTitle.lineBreakMode = .byWordWrapping
      
    }
    
    private func constraint(){
        
        addSubview(image)
        addSubview(title)
        addSubview(subTitle)
        
        image.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50.VAdapted)
            make.size.equalTo([70, 70].HResized)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(15.VAdapted)
            make.centerX.equalToSuperview()
        }
        
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(20.VAdapted)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }

}
