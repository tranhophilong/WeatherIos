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
    let initAlphaColor = 0.8
    var didRemakeConstraint: Bool = false
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
        layer.cornerRadius = 20.HAdapted
        backgroundColor = .brightBlue.withAlphaComponent(initAlphaColor)
    }
    
    private func setupHeader(){
        
        header.backgroundColor = .clear
        header.layer.cornerRadius = 20.HAdapted
        titleLbl.font = AdaptiveFont.bold(size: 16)
        titleLbl.textColor = .white.withAlphaComponent(0.5)
        titleLbl.numberOfLines = 0
        titleLbl.textAlignment = .left
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white.withAlphaComponent(0.5)
        
        
    }
    
    private func setupBody(){
        body.backgroundColor = .clear
//        body.layer.cornerRadius = 50.HAdapted
    }
    

    
    
    func remakeContrainHeader(to view: UIView){
        
        if !didRemakeConstraint{
            view.addSubview(header)
            header.snp.remakeConstraints{ make in
                make.top.equalTo(view.snp.top)
                make.left.equalTo(view.snp.left)
                make.right.equalTo(view.snp.right)
                make.height.equalTo(heighHeader!)
            }
            
            didRemakeConstraint = true

        }
        
    }
    

    func refreshConstrainHeader(){
        
        header.snp.remakeConstraints { [weak self] make in
            self!.topContrainHeader =  make.top.equalTo(self!.snp.top).constraint
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            self!.heightHeaderConstraint =  make.height.equalTo(50).constraint
        }
        
        didRemakeConstraint = false
        
    }
    
    
    
    private func constraint(){
        addSubview(header)
        addSubview(body)
        
        header.snp.makeConstraints { [weak self] make in
            self!.topContrainHeader =  make.top.equalTo(self!.snp.top).constraint
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
            make.top.equalToSuperview().offset(heighHeader ?? 50.VAdapted)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        separator =  addSeparator(width: 0, x: 20.HAdapted, y: 0, to: body)
        
    }
    
}


//MARK: Config CardView

extension CardView{
    
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
    
    func setHeightHeader(height: Int){
        heightHeaderConstraint?.update(offset: height.VAdapted)
        self.heighHeader = height
    }
    
    func setBackGroundForCard(colorHeader: UIColor, colorBody: UIColor){
        self.backgroundColor = colorBody
        header.backgroundColor = colorHeader
    }
    
    
    func hiddenHeader(with alpha: CGFloat){
         self.backgroundColor = .clear
        header.backgroundColor = .brightBlue.withAlphaComponent(initAlphaColor - alpha)
        titleLbl.textColor = titleColor?.withAlphaComponent(initAlphaColor - alpha)
        iconView.tintColor = iconColor?.withAlphaComponent(initAlphaColor - alpha)
    }
    
    func refreshColorHeader(){
        self.titleLbl.textColor = titleColor
        self.iconView.tintColor = iconColor
        header.backgroundColor = .clear
        self.backgroundColor = .brightBlue.withAlphaComponent(initAlphaColor)
    }
    
}


// MARK: Scroll Action

extension CardView{
    
    func isScrollToHeader(with contentOffSet: CGFloat) -> Bool{
//        print(self.frame.maxY -  CGFloat(heighHeader!)  )
//        print(contentOffSet)
        if self.frame.maxY - CGFloat(heighHeader!) <= contentOffSet{
            return true
        }else{
            return false
        }
    }
}
