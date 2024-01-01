//
//  BottomAppBarView.swift
//  Weather
//
//  Created by Long Tran on 22/10/2023.
//

import UIKit
import SnapKit
import Combine

class BottomAppBarView: UIView {
    
    
    private lazy var pageControl  = UIPageControl(frame: .zero)
    lazy var showLstContentBtn = UIImageView(frame: .zero)
    private lazy var showMapBtn = UIImageView(frame: .zero)
    private let viewModel: BottomAppBarViewModel
    private var cancellables = Set<AnyCancellable>()
    
    public init(frame: CGRect, viewModel: BottomAppBarViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
        setupPageControl()
        setupShowMapBtn()
        setupShowLstContentBtn()
        contrain()
        
    }
  
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        
        backgroundColor = .brightBlue.withAlphaComponent(1)
        var separate  =  addSeparator(width: SCREEN_WIDTH(), x: 0, y: 0, to: self)
    }

    
    private func setupPageControl(){
        
        pageControl.isUserInteractionEnabled = false
        
        viewModel.currentPageControl.sink {[weak self] value in
            self?.pageControl.currentPage = value
        }.store(in: &cancellables)
        
        viewModel.numberPageControl.sink {[weak self] value in
            print(value)
            self?.pageControl.numberOfPages = value
        }.store(in: &cancellables)
        
        viewModel.isIndicatorLocationFirst.sink {[weak self] value in
            if value{
                self?.setIndicatorLocationAtFirst()
            }
        }.store(in: &cancellables)
    }
    
    private func setIndicatorLocationAtFirst(){
        pageControl.setIndicatorImage(UIImage(systemName: "location.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), forPage: 0)

        
    }
    
    private func setupShowLstContentBtn(){

        showLstContentBtn.image = UIImage(systemName: "list.bullet", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))?.withRenderingMode(.alwaysTemplate)
        showLstContentBtn.tintColor = .white
        showLstContentBtn.contentMode = .scaleAspectFit
    }
    
    private func setupShowMapBtn(){

        showMapBtn.image = UIImage(systemName: "map", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))?.withRenderingMode(.alwaysTemplate)
        showMapBtn.tintColor = UIColor.white
        showMapBtn.contentMode = .scaleAspectFit
    }
    
    private func contrain(){
        
        addSubview(pageControl)
        addSubview(showMapBtn)
        addSubview(showLstContentBtn)
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10.VAdapted)
        }
        
        showLstContentBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.VAdapted)
            make.right.equalToSuperview().offset(-20.HAdapted)
            make.size.equalTo([30,30].HResized)
        }
        
        showMapBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.VAdapted)
            make.left.equalToSuperview().offset(20.HAdapted)
            make.size.equalTo([30,30].HResized)
        }
        
    }

}
