//
//  CardView.swift
//  Weather
//
//  Created by Long Tran on 23/10/2023.
//

import UIKit
import SnapKit

class CardView: UIView {

    private lazy var header = UIView(frame: .zero)
    private lazy var body = UIView(frame: .zero)
    private lazy var titleLbl = UILabel(frame: .zero)
    private lazy var iconView = UIImageView(frame: .zero)
    private  var separator: UIView?
    
    private(set) var title: String?
    private(set) var icon: UIImage?
    private(set) var heighHeader: Int?
    private(set) var widthSeparator: CGFloat?
    private(set) var titleColor: UIColor?
    private(set) var iconColor: UIColor?
    private var heightHeaderConstraint: Constraint?
    private var widtHIcon: Constraint?
    private var heightIcon: Constraint?
    private var marginIcon: Constraint?
    var topContrainHeader: Constraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupHeader()
        setupBody()
        constraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
//
        clipsToBounds = true
        backgroundColor = .clear
        layer.cornerRadius = 20.HAdapted
        backgroundColor = .white.withAlphaComponent(0.05)
    }
    
    private func setupHeader(){
        
//        header.backgroundColor = .red
        titleLbl.font = AdaptiveFont.bold(size: 16)
        titleLbl.textColor = .white.withAlphaComponent(0.5)
        titleLbl.numberOfLines = 0
        titleLbl.textAlignment = .left
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white.withAlphaComponent(0.5)
        
        
    }
    
    private func setupBody(){
        body.backgroundColor = .clear
    }
    
    func setTitle(title: String){
        titleLbl.text = title
        self.title = title
    }
    
    func setIcon(icon: UIImage?){
        
        self.icon = icon
//        
        if let icon = icon{
            marginIcon?.update(offset: 10.HAdapted)
            iconView.snp.updateConstraints { make in
                make.width.equalTo(20.HAdapted)
            }
        }else{
            marginIcon?.update(inset: 0)
            iconView.snp.updateConstraints { make in
                make.width.equalTo(0.HAdapted)
            }
            
        }
     
        iconView.image = icon
    }
    
    func setWidthSeparator(width: CGFloat){
        separator?.snp.updateConstraints({ make in
            make.width.equalTo(width)
        })
        
        self.widthSeparator = width
        
    }
    
    func setTitleColor(color: UIColor){
        titleLbl.textColor = color
        self.titleColor = color
    }
    
    func setIconColor(color: UIColor){
        iconView.tintColor = color
        self.iconColor = color
    }
    
    func setHeighHeader(height: Int){
        heightHeaderConstraint?.update(offset: height.VAdapted)
        self.heighHeader = height
    }
    
    
    func remakeContrainTopHeader(to view: UIView){
        view.addSubview(header)
//        header.snp.removeConstraints()
        header.snp.remakeConstraints{ make in
            topContrainHeader =  make.top.equalTo(view.snp.top).constraint
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(100)
        }
    }
    
    
    private func constraint(){
        addSubview(header)
        addSubview(body)
        
        header.snp.makeConstraints { [weak self] make in
            topContrainHeader =  make.top.equalTo(self!.snp.top).constraint
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            self!.heightHeaderConstraint =  make.height.equalTo(50).constraint
        }
        
        header.addSubview(titleLbl)
        header.addSubview(iconView)
        
        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20.HAdapted)
            make.centerY.equalToSuperview()
            make.height.equalTo(30.VAdapted)
            make.width.equalTo(0)
            
        }
        
        titleLbl.snp.makeConstraints { make in
            marginIcon =  make.left.equalTo(iconView.snp.right).offset(0.HAdapted).constraint
            make.centerY.equalTo(iconView)
            make.right.equalToSuperview().offset(-20.HAdapted)
        }
        
        
        body.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        separator =  addSeparator(width: 0, x: 20.HAdapted, y: 0, to: body)
        
    }
    
}
