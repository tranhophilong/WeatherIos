//
//  WeatherViewCell.swift
//  Weather
//
//  Created by Long Tran on 07/11/2023.
//

import UIKit
import SnapKit
import Combine


class WeatherCell: UITableViewCell {

    static let identifier = "WeatherViewCell"
    
    private lazy var titleLbl = UILabel(frame: .zero)
    private lazy var subtileLbl = UILabel(frame: .zero)
    private lazy var conditionLbl = UILabel(frame: .zero)
    private lazy var degreeLbl = UILabel(frame: .zero)
    private lazy var highLowDegreeLbl = UILabel(frame: .zero)
    private  lazy var backgroundImgView = UIImageView(frame: .zero)
    private  var heightConstraint : Constraint?
    private let font1 = AdaptiveFont.bold(size: 20.HAdapted)
    private let font2 = AdaptiveFont.bold(size: 15.HAdapted)
    private let font3 = AdaptiveFont.medium(size: 40.HAdapted)
    private let lblColor: UIColor = .white
    private var cancellales = Set<AnyCancellable>()
    var viewModel: WeatherCellViewModel!{
        didSet{
            setupBinder()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constraint()
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 15.HAdapted
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBinder(){
        viewModel.condtion.sink { [weak self] condition in
            self?.conditionLbl.text = condition
        }.store(in: &cancellales)
        
        viewModel.currentDegree.sink { [weak self] currentDegree in
            self?.degreeLbl.text = currentDegree
        }.store(in: &cancellales)
        
        viewModel.backgroundName.sink { [weak self] backgroundName in
            self?.backgroundImgView.image = UIImage(named: backgroundName)
        }.store(in: &cancellales)
        
        viewModel.highLowDegree.sink {[weak self] value in
            self?.highLowDegreeLbl.text = value
        }.store(in: &cancellales)
        
        viewModel.location.sink { [weak self] location in
            self?.titleLbl.text = location
        }.store(in: &cancellales)
        
        viewModel.time.sink { [weak self] time in
            self?.subtileLbl.text = time
        }.store(in: &cancellales)
        
        viewModel.isClearBackground.sink {[weak self] isClear in
//            if isClear{
//                self?.backgroundImgView.image = nil
//                self?.backgroundImgView.backgroundColor = .clear
//            }
        }.store(in: &cancellales)
        
        viewModel.isHiddenConditionLbl.sink { [weak self] isHidden in
            self?.conditionLbl.isHidden = isHidden
        }.store(in: &cancellales)
        
        viewModel.isHighLowLbl.sink { [weak self] isHidden in
            self?.highLowDegreeLbl.isHidden = isHidden
        }.store(in: &cancellales)
        
    }
    
    private func setupViews(){
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
