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
    private let heightHeaderContent: Int = Int(370.VAdapted)
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
        cardView.setHeighHeader(height: 50)
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
        
        
        containerView.snp.makeConstraints {[weak self] make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        containerView.addSubview(headerContent)
        
        headerContent.snp.makeConstraints { [weak self] make in
            make.top.equalTo(self!.snp_topMargin)
            make.left.equalTo(self!.snp.left)
            make.right.equalTo(self!.snp.right)
            heightHeaderContentConstraint =  make.height.equalTo(heightHeaderContent.VAdapted).constraint
        }
        
//        headerContent.backgroundColor = .gray
        
        containerView.addSubview(cardView)
        
        cardView.snp.makeConstraints { make in
            make.top.equalTo(headerContent.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(350.VAdapted)
            
        }
//        
        
    }
}

extension ContentView: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//            minis margin top of Screen
        var contentOffSet = -scrollView.contentOffset.y - 44.VAdapted
        
        if (CGFloat(heightHeaderContent) + contentOffSet - 10.VAdapted >= CGFloat(74.VAdapted) ){
            heightHeaderContentConstraint?.update(offset: heightHeaderContent + Int(contentOffSet))
            headerContent.changeDisLblAndTopHeaderDidScroll(scrollView: scrollView)
            headerContent.hiddenLabelDidScroll(scrollView: scrollView)
        }
      
    }
}


