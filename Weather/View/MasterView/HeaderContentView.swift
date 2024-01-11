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
    
    private lazy var locationLbl = UILabel(frame: .zero)
    private lazy var degreeLbl = UILabel(frame: .zero)
    private lazy var conditionWeatherLbl = UILabel(frame: .zero)
    private lazy var highLowDegreeLbl = UILabel(frame: .zero)
    private lazy var degreeIcon = UILabel(frame: .zero)
    private lazy var  degreeConditionLbl = UILabel(frame: .zero)
    private let viewModel: HeaderContentViewModel
    private var cancellables = Set<AnyCancellable>()
    private let lblColor: UIColor = .white
    private var locationLblToTopHeaderConstraint: Constraint?
    
    private let heightHeaderContent: CGFloat
    private lazy var disConditionLblAndDegreeLbl: CGFloat = round(heightHeaderContent * 0.027)
    private lazy var disHightLowDegreeLblAndConditionWeatherLbl: CGFloat = round(heightHeaderContent * 0.027)
    private lazy var didsDegreeLblAndLocationLbl: CGFloat = round(heightHeaderContent * 0.027)

    private lazy var disLocationLblAndTopHeaderStart: CGFloat = heightHeaderContent / 5
    private lazy var disDegreeLblAndBottomHeader: CGFloat = heightHeaderContent * 2/5
    private lazy var disConditionWeatherLblAndBottomHeader: CGFloat = round(heightHeaderContent * 0.3)
    private lazy var disDegreeConditionAndBottomHeader: CGFloat = round(heightHeaderContent * 0.627)
    private lazy var disHighLowDegreeLblAndBottomHeader: CGFloat = heightHeaderContent/5

    private lazy var heightHighAndLowDegreeLbl: CGFloat = round(heightHeaderContent * 0.073)
    private lazy var heightConditionLbl: CGFloat = round(heightHeaderContent * 0.073)
    private lazy var heightDegreeLbl: CGFloat = heightHeaderContent/5
        
    private lazy var fontDegreeLbl = UIFont.systemFont(ofSize: round(heightHeaderContent * 0.27), weight: .thin)
    private lazy var fontConditionLbl = UIFont.systemFont(ofSize: round(heightHeaderContent * 0.054), weight: .bold)
    private lazy var fontLocationLbl = UIFont.systemFont(ofSize: round(heightHeaderContent * 0.108), weight: .regular)
    

    public init(frame: CGRect, viewModel: HeaderContentViewModel, heightHedaerContent: CGFloat) {
        self.heightHeaderContent = heightHedaerContent
        self.viewModel = viewModel
        super.init(frame: frame)
        setupViews()
        constraint()
        setupBinderChangeAlphaColorLbls()
        setupBinder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBinder(){
        
        viewModel.nameLocation.sink {[weak self] value in
            self?.locationLbl.text = value

        }.store(in: &cancellables)
        
        viewModel.currentDegree.sink {[weak self] value in
            self?.degreeLbl.text = value
            
        }.store(in: &cancellables)
        
        viewModel.highLowDegree.sink {[weak self] value in
            self?.highLowDegreeLbl.text = value
        }.store(in: &cancellables)
        
        
        viewModel.condition.sink {[weak self] value in
            self?.conditionWeatherLbl.text = value
        }.store(in: &cancellables)
        
        viewModel.conditionDegree.sink { [weak self] value in
            self?.degreeConditionLbl.text = value
        }.store(in: &cancellables)
        
        viewModel.isHiddenDegreeIcon.sink { [weak self] isHidden in
            self?.degreeIcon.isHidden = isHidden
        }.store(in: &cancellables)
    }
    
    private func setupViews(){
        
//        font
        degreeLbl.font = fontDegreeLbl
        conditionWeatherLbl.font = fontConditionLbl
        highLowDegreeLbl.font = fontConditionLbl
        degreeConditionLbl.font = fontConditionLbl
        locationLbl.font = fontLocationLbl
        
//      color
        locationLbl.textColor = lblColor
        degreeLbl.textColor = lblColor
        conditionWeatherLbl.textColor = lblColor
        highLowDegreeLbl.textColor = lblColor
        degreeConditionLbl.textColor = lblColor
        
        degreeConditionLbl.isHidden = false
        degreeIcon.isHidden = true
        
//        Degree Icon
        degreeIcon.text = "°"
        degreeIcon.textColor  = .white
        degreeIcon.font = fontDegreeLbl
    }
      
    private func setupBinderChangeAlphaColorLbls(){
        viewModel.alphaColorhightLowDegreeLbl.sink {[weak self] alpha in
            self!.highLowDegreeLbl.textColor = self!.lblColor.withAlphaComponent(alpha)
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
        addSubview(highLowDegreeLbl)
        addSubview(degreeIcon)
        addSubview(degreeConditionLbl)
        
        
        locationLbl.snp.makeConstraints { make in
            make.centerX.equalTo(degreeLbl)
            locationLblToTopHeaderConstraint =  make.top.equalToSuperview().offset(disLocationLblAndTopHeaderStart ).constraint
            make.height.equalTo(round(heightHeaderContent * 0.173))
        }
        
        degreeConditionLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(round(heightHeaderContent * 0.073))
            make.top.equalTo(locationLbl.snp.bottom).offset(5.VAdapted)
        }
        
        degreeLbl.snp.makeConstraints { make in
            make.top.equalTo(locationLbl.snp.bottom).offset( didsDegreeLblAndLocationLbl)
            make.centerX.equalToSuperview()
            make.height.equalTo(heightDegreeLbl)
        }
        
        degreeIcon.snp.makeConstraints { make in
            make.centerY.firstBaseline.equalTo(degreeLbl)
            make.left.equalTo(degreeLbl.snp.right).offset(5.HAdapted)
        }
        
        
        conditionWeatherLbl.snp.makeConstraints { make in
            make.top.equalTo(degreeLbl.snp.bottom).offset(disConditionLblAndDegreeLbl)
            make.centerX.equalTo(degreeLbl)
            make.height.equalTo(heightConditionLbl)
        }
        
        highLowDegreeLbl.snp.makeConstraints { make in
            make.centerX.equalTo(degreeLbl)
            make.top.equalTo(conditionWeatherLbl.snp.bottom).offset(disHightLowDegreeLblAndConditionWeatherLbl)
            make.height.equalTo(heightHighAndLowDegreeLbl)
        }
        
    }
   
}
//MARK: - Animation Scroll

extension HeaderContentView{
    func changeDisLblAndTopHeaderDidScroll(contentOffset: CGFloat){
        viewModel.changeDisLblAndTopHeaderDidScroll(with: contentOffset, heightHeaderStart: disLocationLblAndTopHeaderStart, heightHightAndLowDegreeLbl: heightHighAndLowDegreeLbl)
    }
    
    func changeColorLbl(contentOffSet: CGFloat){
        viewModel.changeColorLbl(with: contentOffSet, disHighLowDegreeLblAndBottomHeader: disHighLowDegreeLblAndBottomHeader, disConditionWeatherLblAndBottomHeader: disConditionWeatherLblAndBottomHeader, disDegreeLblAndBottomHeader: disDegreeLblAndBottomHeader, disDegreeConditionAndBottomHeader: disDegreeConditionAndBottomHeader, heightDegreeLbl: heightDegreeLbl, heightHighAndLowDegreeLbl: heightHighAndLowDegreeLbl, heightConditionLbl: heightConditionLbl)
    }
  
}
