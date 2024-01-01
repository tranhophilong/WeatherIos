//
//  BarGradientColorView.swift
//  Weather
//
//  Created by Long Tran on 25/11/2023.
//

import UIKit
import SnapKit
import Combine

class GradientColorView: UIView {
    
    private lazy var background = UIView(frame: .zero)
    private lazy var gradientColorCA = CAGradientLayer()
    private lazy var currentIndexCA = CALayer()
    private lazy var boderCurrentIndexCA = CALayer()
    private lazy var widthGradientColor: CGFloat = 0
    private var cancellables = Set<AnyCancellable>()

    var viewModel: GradientColorViewModel!{
        didSet{
            setupBinder()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientColorCA()
        setupCurrentIndexCA()
        constraint()
        setupBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        widthGradientColor = self.frame.width
        viewModel.getFrameGradient(with: widthGradientColor)
        viewModel.getFrameCurrentIndexCA(with: widthGradientColor)
        viewModel.getColorGradients()
        viewModel.getGradientLocation()
    }

    
    private func setupBinder(){
        viewModel.isShowCurrentIndex.sink {[weak self] value in
            self?.boderCurrentIndexCA.isHidden = !value
            self?.currentIndexCA.isHidden = !value
        }.store(in: &cancellables)
        
        viewModel.gradientColors.sink {[weak self] cgColors in
            self?.gradientColorCA.colors = cgColors
        }.store(in: &cancellables)
        
        viewModel.gradientLocations.sink {[weak self] locations in
            self?.gradientColorCA.locations = locations
        }.store(in: &cancellables)
        
        viewModel.frameCurrentIndexCA.sink {[weak self] frame in
            self?.currentIndexCA.frame = frame
        }.store(in: &cancellables)
        
        viewModel.frameGradientColorCA.sink { [weak self] frame in
            self?.gradientColorCA.frame = frame
        }.store(in: &cancellables)
        
    }
    
    private func setupGradientColorCA(){
        
        gradientColorCA.frame = .zero
        gradientColorCA.cornerRadius = 5.HAdapted/2
        gradientColorCA.startPoint = CGPoint(x: 0, y: 0.5)
        gradientColorCA.endPoint = CGPoint(x: 1, y: 0.5)
        
        background.layer.insertSublayer(gradientColorCA, at: 0)

    }
    
    private func setupCurrentIndexCA(){
        
        currentIndexCA.backgroundColor = UIColor.white.cgColor
        currentIndexCA.cornerRadius = 5.HAdapted/2
        currentIndexCA.borderColor = UIColor.brightBlue.cgColor
        
        boderCurrentIndexCA = CALayer()
        boderCurrentIndexCA.backgroundColor =  UIColor.brightBlue.cgColor
        boderCurrentIndexCA.cornerRadius = 10.HAdapted/2
        
        currentIndexCA.frame = .zero
        boderCurrentIndexCA.frame = CGRect(x: 0, y: 0, width: 10.HAdapted, height: 10.VAdapted)
        boderCurrentIndexCA.position = CGPoint(x: currentIndexCA.frame.midX, y: currentIndexCA.frame.midY)
        
        background.layer.insertSublayer(boderCurrentIndexCA, at: 1)
        background.layer.insertSublayer(currentIndexCA, at: 2)
    }
    
    private func setupBackground(){
        
        backgroundColor = .clear
        background.backgroundColor = .darkGray
        background.layer.cornerRadius =  5.HAdapted / 2
    }
    
    private func constraint(){
        addSubview(background)
        background.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }

}
