//
//  BodyContentView.swift
//  Weather
//
//  Created by Long Tran on 29/10/2023.
//

import UIKit
import SnapKit


class BodyContentView: UIView {
    
    var lstCardViewItem: [CardViewItem] = []{
        didSet{
            reloadContainerView()
            layoutSubViews()
        }
    }
    var spacingItem: CGFloat = 10.VAdapted{
        didSet{
            reloadContainerView()
            layoutSubViews()
        }
    }
    
    
    
    private let containerView = UIScrollView(frame: .zero)
    private(set) var heightContent: CGFloat = 0
    private(set) var widthContent: CGFloat = 0
    private var isOverScroll: Bool = true
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraint()
        setupContainerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupContainerView(){
        containerView.backgroundColor = .white.withAlphaComponent(0)
        containerView.isPagingEnabled = false
        containerView.isScrollEnabled = false
        containerView.showsVerticalScrollIndicator = false
        widthContent = self.frame.width
        
    }
    private func layoutSubViews(){
        var currentViewOffset = CGFloat(0);
        for cardViewItem in lstCardViewItem{
            let frame = CGRectMake(0, currentViewOffset, cardViewItem.content.frame.width, cardViewItem.content.frame.height)
            let cardView = CardView(frame: frame)
            cardView.setIcon(icon: cardViewItem.icon)
            cardView.setTitle(title: cardViewItem.title)
            cardView.setIconColor(color: cardViewItem.iconColor)
            cardView.setTitleColor(color: cardViewItem.titleColor)
            cardView.setHeightHeader(height: cardViewItem.heightHeader)
            cardView.setWidthSeparator(width: cardViewItem.widthSeparator)
            containerView.addSubview(cardView)
            currentViewOffset += spacingItem + cardViewItem.content.frame.height
        }
    }
    
    private func reloadContainerView(){
        heightContent = 0
        for cardViewItem in lstCardViewItem{
            heightContent += cardViewItem.content.frame.height + CGFloat(cardViewItem.heightHeader)
        }
  

        containerView.contentSize = CGSize(width: widthContent, height: heightContent + CGFloat(lstCardViewItem.count) * spacingItem)
        containerView.subviews.forEach { view in
            view.removeFromSuperview()
        }
    }
    
    
        
    private func constraint(){
        
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    
}


//MARK: Scroll Action

extension BodyContentView{
    
    func viewDidScroll(with scrollView: UIScrollView, and contentOffSetDidScroll: CGFloat){
        let contentOffSet = scrollView.contentOffset.y - contentOffSetDidScroll
        containerView.contentOffset.y = contentOffSet
        for view in containerView.subviews{
            if let cardView = view as? CardView{
                if contentOffSet >= cardView.frame.minY{
                    cardView.remakeContrainHeader(to: self)

                }else{
                    cardView.refreshConstrainHeader()

                }
                if cardView.isScrollToHeader(with: contentOffSet ){
                    let alpha = (contentOffSet - cardView.frame.maxY) / CGFloat(cardView.heighHeader!) * -1
                    cardView.hiddenHeader(with: 1 - alpha)
                }else{
                    cardView.refreshColorHeader()
                }
  
            }

        }
        
//        print(containerView.subviews.count)
         
    }
    
    func refreshScroll(){
        isOverScroll = true
       
    }
    
    
    func refreshHeaderSubview(){
        
        containerView.subviews.forEach {view in
            if view is CardView == false {
                view.removeFromSuperview()
            }
        }
        
        containerView.subviews.forEach { view in
            if let cardView = view as? CardView{
                cardView.refreshConstrainHeader()
            }
        }
        
    }
    
    func checkContentOffSetIsZero() -> Bool{
        if containerView.contentOffset.y <= 0 {
            return true
        }else{
            return false
        }
    }
    
 
}



