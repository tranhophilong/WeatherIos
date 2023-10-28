//
//  BottomAppBarView.swift
//  Weather
//
//  Created by Long Tran on 22/10/2023.
//

import UIKit
import SnapKit

class BottomAppBarView: UIView {
    
    var numberPageControll : Int?{
        didSet{
            pageControl.numberOfPages = numberPageControll!
        }
    }
    
    var currentPage : Int?{
        didSet{
            pageControl.currentPage = currentPage!
        }
    }
    
    private lazy var pageControl  = UIPageControl(frame: .zero)
    private lazy var showLstContentBtn = UIImageView(frame: .zero)
    private lazy var showMapBtn = UIImageView(frame: .zero)
    
    override init(frame: CGRect) {
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
        backgroundColor = .blueRas.withAlphaComponent(0.6)
        var separate  =  addSeparator(width: SCREEN_WIDTH(), x: 0, y: 0, to: self)
    }

    
    private func setupPageControl(){
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = 1
        pageControl.currentPage = 0
        pageControl.setIndicatorImage(UIImage(systemName: "location.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), forPage: 0)
        
    }
    
    private func setupShowLstContentBtn(){

        showLstContentBtn.image = UIImage(systemName: "list.bullet", withConfiguration: UIImage.SymbolConfiguration(weight: .light))?.withRenderingMode(.alwaysTemplate)
        showLstContentBtn.tintColor = .white
        showLstContentBtn.contentMode = .scaleAspectFit
    }
    
    private func setupShowMapBtn(){

        showMapBtn.image = UIImage(systemName: "map", withConfiguration: UIImage.SymbolConfiguration(weight: .light))?.withRenderingMode(.alwaysTemplate)
        showMapBtn.tintColor = UIColor.white
        showMapBtn.contentMode = .scaleAspectFit
    }
    
    private func contrain(){
        
        addSubview(pageControl)
        addSubview(showMapBtn)
        addSubview(showLstContentBtn)
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10.HAdapted)
            
        }
        
        showLstContentBtn.snp.makeConstraints { make in
            make.centerY.equalTo(pageControl)
            make.right.equalToSuperview().offset(-20.HAdapted)
            make.size.equalTo([30,30].HResized)
        }
        
        showMapBtn.snp.makeConstraints { make in
            make.centerY.equalTo(pageControl)
            make.left.equalToSuperview().offset(20.HAdapted)
            make.size.equalTo([30,30].HResized)
        }
        
        
    }

}
