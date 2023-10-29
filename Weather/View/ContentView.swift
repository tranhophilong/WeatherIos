//
//  ContentView.swift
//  Weather
//
//  Created by Long Tran on 22/10/2023.
//

import UIKit
import SnapKit

class ContentView: UIView{
    
    private lazy var containerView = UIScrollView(frame: .zero)
    private lazy var lbl = UILabel(frame: .zero)
    private lazy var cardView = CardView(frame: .zero)
    private lazy var headerContent = HeaderContentView(frame: .zero)
    private var heightHeaderContentConstraint: Constraint?
    let title : String
    
    
    public init(frame: CGRect, title: String) {
        self.title = title
        super.init(frame: frame)
        
        setupContainerView()
        setupSubViews()
        constraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    private func setupSubViews(){
        cardView.setTitle(title: "Weather")
        cardView.setWidthSeparator(width: SCREEN_WIDTH())
        cardView.setTitleColor(color: .white)
        cardView.setIconColor(color: .white)
        cardView.setHeighHeader(height: Int(50.VAdapted))
        cardView.setIcon(icon: UIImage(systemName: "figure.stand.line.dotted.figure.stand"))
//        cardView.remakeContrainTopHeader(to: self)
        
    }
    
    private func setupContainerView(){
        
        containerView.backgroundColor = .white.withAlphaComponent(0)
        containerView.isPagingEnabled = false
        containerView.showsVerticalScrollIndicator = false
        containerView.contentSize = CGSize(width: self.frame.width, height: self.frame.height * 3)
        containerView.delegate = self
        
//        containerView.backgroundColor = .brown
    }
    
    private func constraint(){
        
        addSubview(containerView)
        
        
        containerView.snp.makeConstraints {make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        containerView.addSubview(headerContent)
        
        headerContent.snp.makeConstraints { [weak self] make in
            make.top.equalTo(self!.snp.topMargin)
            make.left.equalTo(self!.snp.left)
            make.right.equalTo(self!.snp.right)
            self!.heightHeaderContentConstraint =  make.height.equalTo(heightHeaderContent).constraint
        }
        
//        headerContent.backgroundColor = .gray
        
        containerView.addSubview(cardView)
        
        cardView.snp.makeConstraints {[weak self] make in
            make.top.equalTo(self!.headerContent.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(self!.frame.width * 90/100)
            make.height.equalTo(350.VAdapted)
            
        }
//        
        
    }
}

extension ContentView: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//            minis margin top of Screen
        var contentOffSet = -scrollView.contentOffset.y - STATUS_BAR_HEIGHT()
//        print(-scrollView.contentOffset.y)
//        print(STATUS_BAR_HEIGHT())
        if (CGFloat(heightHeaderContent) + contentOffSet - 10.VAdapted >= CGFloat(74.VAdapted) ){
            heightHeaderContentConstraint?.update(offset: heightHeaderContent + contentOffSet)
            headerContent.changeDisLblAndTopHeaderDidScroll(scrollView: scrollView)
            headerContent.hiddenLabelDidScroll(scrollView: scrollView)
        }
      
    }
}


