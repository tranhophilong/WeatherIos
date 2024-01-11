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
    private  var separator: UIView?
    private let viewModel: CardViewModel
    private let heightHeader: CGFloat = 40.VAdapted
    private var widthSeparator: CGFloat?
    private lazy var titleColor: UIColor = .white
    private lazy var iconColor: UIColor = .white
    private var heightHeaderConstraint: Constraint?
    private var widthIcon: Constraint?
    private var heightIcon: Constraint?
    private var marginIcon: Constraint?
    var topContrainHeader: Constraint?

    public init(frame: CGRect, viewModel: CardViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupBody()
        constraint()
        setupBindToChangeAlphaColor()
        setupView()
        setupHeader()
        viewModel.getData()
        
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

        viewModel.title.sink {[weak self] title in
            self!.titleLbl.text = title
        }.store(in: &cancellables)
        
        titleLbl.textColor = titleColor
        iconView.contentMode = .scaleAspectFit
        
        viewModel.icon.sink {[weak self] icon in
            self!.iconView.image = icon
        }.store(in: &cancellables)
        
        iconView.tintColor = iconColor
        
    }
    
    private func setupBody(){
        body.backgroundColor = .clear
    
        viewModel.contentCardViewModel.sink {[weak self] viewModel in
            var contentBodyView = UIView()
            switch viewModel{
            case is TenDayForecastViewModel:
                if let viewModel = viewModel as? TenDayForecastViewModel{
                    contentBodyView = TenDayForecastView(frame: .zero, viewModel: viewModel)
                }
                
            case is HourlyForecastViewModel:
                if let viewModel = viewModel as? HourlyForecastViewModel{
                    contentBodyView = HourlyForecastView(frame: .zero, viewModel: viewModel)
                }
            
            case is ForecastViewModel:
                if let viewModel = viewModel as? ForecastViewModel{
                    contentBodyView = ForecastView(frame: .zero, viewModel: viewModel)
                }
            default:
                break
            }
            
            self!.body.addSubview(contentBodyView)
            
            contentBodyView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
        }.store(in: &cancellables)
      
    }
    
    private func setupBindToChangeAlphaColor(){
        viewModel.alphaColorBackgroundCardView.sink { [weak self] alpha in
            self!.backgroundColor = .brightBlue.withAlphaComponent(alpha)
        }.store(in: &cancellables)
        
        viewModel.alphaColorBackgroundHeader.sink { [weak self] alpha in
            self?.header.backgroundColor = .brightBlue.withAlphaComponent(alpha)
        }.store(in: &cancellables)
        
        viewModel.alphaColorTitleAndIcon.sink { [weak self] alpha in
            self!.titleLbl.textColor = self!.titleColor.withAlphaComponent(alpha)
            self!.iconView.tintColor = self!.iconColor.withAlphaComponent(alpha)
        }.store(in: &cancellables)
        
        
        viewModel.hiddenBody.sink {[weak self] value in
            self!.body.isHidden = value
        }.store(in: &cancellables)
    }
    
    func setupBindToPinHeader(to view: UIView){
        viewModel.remakeConstraintHeader.sink { [weak self, weak view] value in
            if value{
                self!.header.snp.remakeConstraints{  make in
                    make.top.equalTo(view!.snp.top)
                    make.left.equalTo(self!.snp.left)
                    make.right.equalTo(self!.snp.right)
                    make.height.equalTo(self!.heightHeader)
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
            self!.heightHeaderConstraint =  make.height.equalTo(self!.heightHeader).constraint
        }
        
    }

    private func constraint(){
        addSubview(header)
        addSubview(body)
        
        header.snp.makeConstraints { [weak self] make in
            self!.topContrainHeader =  make.top.equalTo(self!.snp.top).constraint
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            self!.heightHeaderConstraint =  make.height.equalTo(self!.heightHeader).constraint
        }
        
        header.addSubview(titleLbl)
        header.addSubview(iconView)
        
        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20.HAdapted)
            make.centerY.equalToSuperview()
            make.height.equalTo(30.VAdapted)
            make.width.equalTo(20.HAdapted)
            
        }
        
        titleLbl.snp.makeConstraints { make in
            marginIcon =  make.left.equalTo(iconView.snp.right).offset(5.HAdapted).constraint
            make.centerY.equalTo(iconView)
            make.right.equalToSuperview().offset(-20.HAdapted)
        }
        
        
        body.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(heightHeader)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        separator =  addSeparator(width: 0, x: 10.HAdapted, y: 0, to: body)
        
    }
    
}

// MARK: - Scroll Action
extension CardView{
    func changeAlphaColorTopHeader(contentOffset: CGFloat){
        
        viewModel.changeAlphaColorTopHeader(with: contentOffset, maxYCardView: self.frame.maxY, heightHeaderCardView: CGFloat(heightHeader))
    }
    
    func pinHeader(contentOffSet: CGFloat){
        let minY = self.frame.minY
        viewModel.pinHeaderToTop(contentOffSet: contentOffSet, minYCardView: minY)
    }
    
    
}

