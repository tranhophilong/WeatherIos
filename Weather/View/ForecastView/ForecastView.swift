//
//  ForecastView.swift
//  Weather
//
//  Created by Long Tran on 05/11/2023.
//

import UIKit
import SnapKit
import Combine

class ForecastView: UIView {
   
    private lazy var  indexLbl = UILabel(frame: .zero)
    private lazy var  descriptionLbl = UILabel(frame: .zero)
    private lazy  var descriptionView = UIView(frame: .zero)
    private lazy var subDescription = UILabel(frame: .zero)
    
    private let indexLblFont = AdaptiveFont.bold(size: 25.HAdapted)
    private let desLblFont = AdaptiveFont.bold(size: 17.HAdapted)
    private let subDesFont = AdaptiveFont.medium(size: 15.HAdapted)
    
    private let lblColor: UIColor = .white
   unowned private let viewModel: ForecastViewModel
    private var cancellabels = Set<AnyCancellable>()
    
    public init(frame: CGRect, viewModel: ForecastViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupIndexLbl()
        setupDescriptionLbl()
        setupSubDescription()
        setupDescriptionView()
        setupBinder()
        constraint()
        viewModel.getData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBinder(){
        
        viewModel.description.sink {[weak self] value in
            self?.descriptionLbl.text = value
        }.store(in: &cancellabels)
        
        viewModel.index.sink {[weak self] value in
            self?.indexLbl.text = value
        }.store(in: &cancellabels)
        
        viewModel.subDescription.sink {[weak self] value in
            self?.subDescription.text = value
        }.store(in: &cancellabels)
        
//        viewModel.subDescriptionViewModel.sink {[weak self] viewModel in
//            
//        }.store(in: &cancellabels)
    }
    
    private func setupIndexLbl(){
        indexLbl.font = indexLblFont
        indexLbl.textColor = lblColor
        indexLbl.textAlignment = .left
    }

    private func setupDescriptionLbl(){
        descriptionLbl.font = desLblFont
        descriptionLbl.textColor = lblColor
        descriptionLbl.textAlignment = .left
    }
    
    private func setupSubDescription(){
        subDescription.font = subDesFont
        subDescription.textColor = lblColor
        subDescription.textAlignment = .left
        subDescription.numberOfLines = 0
        subDescription.lineBreakMode = .byWordWrapping
    }
    
    private func setupDescriptionView(){
        descriptionView.backgroundColor = .clear
    }
    
    private func constraint(){
//        addSubview(stackViewVer)
        addSubview(indexLbl)
        addSubview(descriptionLbl)
        addSubview(subDescription)
        addSubview(descriptionView)

        indexLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.VAdapted)
            make.left.equalToSuperview().offset(10.HAdapted)
        }
        
        descriptionLbl.snp.makeConstraints {[weak self] make in
            make.top.equalTo(self!.indexLbl.snp.bottom).offset(5.VAdapted)
            make.left.equalToSuperview().offset(10.HAdapted)
        }
        
        descriptionView.snp.makeConstraints {[weak self] make in
            make.left.equalToSuperview().offset(10.HAdapted)
            make.right.equalToSuperview().offset(-15.HAdapted)
            make.top.equalTo(self!.descriptionLbl.snp.bottom).offset(10.VAdapted)
            make.bottom.equalTo(self!.subDescription.snp.top)
        }
        
        subDescription.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10.VAdapted)
            make.left.equalToSuperview().offset(10.HAdapted)
        }

    }
    
}
