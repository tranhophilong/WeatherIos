//
//  CardView.swift
//  Weather
//
//  Created by Long Tran on 23/10/2023.
//

import UIKit
import SnapKit
import Combine

class CardView: UIView {

    lazy var header = UIView(frame: .zero)
    private lazy var body = UIView(frame: .zero)
    private lazy var titleLbl = UILabel(frame: .zero)
    private lazy var iconView = UIImageView(frame: .zero)
    private var cancellables = Set<AnyCancellable>()
    let cardViewMdoel = CardViewModel()
    
    private  var separator: UIView?
    private(set) var title: String?
    private(set) var icon: UIImage?
    private(set) var heightHeader: Int?
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
        setupBindToChangeAlphaColor()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
//
        clipsToBounds = true
        layer.cornerRadius = 15.HAdapted
    }
    
    private func setupHeader(){
        header.clipsToBounds = true
        header.backgroundColor = .clear
        header.layer.cornerRadius = 15.HAdapted
        titleLbl.font = AdaptiveFont.bold(size: 13.HAdapted)
        titleLbl.numberOfLines = 0
        titleLbl.textAlignment = .left
        iconView.contentMode = .scaleAspectFit
        
    }
    
    private func setupBody(){
          body.backgroundColor = .clear
    }
    
    private func setupBindToChangeAlphaColor(){
        cardViewMdoel.alphaColorBackgroundCardView.sink { [weak self] alpha in
            self!.backgroundColor = .brightBlue.withAlphaComponent(alpha)
        }.store(in: &cancellables)
        
        cardViewMdoel.alphaColorBackgroundHeader.sink { [weak self] alpha in
            self?.header.backgroundColor = .brightBlue.withAlphaComponent(alpha)
        }.store(in: &cancellables)
        
        cardViewMdoel.alphaColorTitleAndIcon.sink { [weak self] alpha in
            self!.titleLbl.textColor = self!.titleColor?.withAlphaComponent(alpha)
            self!.iconView.tintColor = self!.iconColor?.withAlphaComponent(alpha)
        }.store(in: &cancellables)
        
        
        cardViewMdoel.hiddenBody.sink {[weak self] value in
            if value{
                self!.body.isHidden = true
            }else{
                self!.body.isHidden = false
            }
        }.store(in: &cancellables)
    }
    
    func setupBindToPinHeader(to view: UIView){
        cardViewMdoel.remakeConstraintHeader.sink { [weak self] value in
            if value{
                self!.header.snp.remakeConstraints{  make in
                    make.top.equalTo(view.snp.top)
                    make.left.equalTo(self!.snp.left)
                    make.right.equalTo(self!.snp.right)
                    make.height.equalTo(self!.heightHeader!)
                }
            }else{
                
                self!.refreshConstrainHeader()
            }
        }.store(in: &cancellables)
    }
    


    
    func refreshConstrainHeader(){
        header.snp.remakeConstraints { [weak self] make in
            self!.topContrainHeader =  make.top.equalTo(self!.snp.top).constraint
            make.left.equalTo(self!.snp.left)
            make.right.equalTo(self!.snp.right)
            self!.heightHeaderConstraint =  make.height.equalTo(40.VAdapted).constraint
        }
        
    }

    private func constraint(){
        addSubview(header)
        addSubview(body)
        
        header.snp.makeConstraints { [weak self] make in
            self!.topContrainHeader =  make.top.equalTo(self!.snp.top).constraint
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            self!.heightHeaderConstraint =  make.height.equalTo(40.VAdapted).constraint
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
            make.top.equalToSuperview().offset(heightHeader ?? 40.VAdapted)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        separator =  addSeparator(width: 0, x: 10.HAdapted, y: 0, to: body)
        
    }
    
}


//MARK: -Config CardView

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
        self.heightHeader = height
    }
    
    func setBackGroundForCard(colorHeader: UIColor, colorBody: UIColor){
        self.backgroundColor = colorBody
        header.backgroundColor = colorHeader
    }
    
    func setContentBody(view: UIView){
        body.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    

    
}



// MARK: - Scroll Action
extension CardView{
    func changeAlphaColorTopHeader(contentOffset: CGFloat){
        
        cardViewMdoel.changeAlphaColorTopHeader(with: contentOffset, maxYCardView: self.frame.maxY, heightHeaderCardView: CGFloat(heightHeader!))
    }
    
    func pinHeader(contentOffSet: CGFloat){
        let minY = self.frame.minY
        cardViewMdoel.pinHeaderToTop(contentOffSet: contentOffSet, minYCardView: minY)
    }
    
    
}

