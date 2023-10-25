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
    }
    
    private func setupContainerView(){
        
        containerView.backgroundColor = .white.withAlphaComponent(0)
        containerView.isPagingEnabled = false
        containerView.showsVerticalScrollIndicator = false
        containerView.contentSize = CGSize(width: self.frame.width, height: self.frame.height)
    }
    
    private func constraint(){
        
        addSubview(containerView)
        addSubview(lbl)
        
        lbl.text = title
        lbl.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        containerView.addSubview(cardView)
        
        cardView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(300)
            
        }
        
        
    }
}


class HeaderContentView: UIView{
    
}
