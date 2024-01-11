//
//  BodyContentView.swift
//  Weather
//
//  Created by Long Tran on 29/10/2023.
//

import UIKit
import SnapKit
import Combine


class BodyContentView: UIView {
    
   private let containerView = UIScrollView(frame: .zero)
   private let viewModel: BodyContentViewModel
   private var cancellables = Set<AnyCancellable>()
    
   public init(frame: CGRect, viewModel: BodyContentViewModel) {
       self.viewModel = viewModel
       super.init(frame: frame)
       constraint()
       setupBinder()
       setupContainerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBinder(){
        viewModel.cardViewWillDisplay.sink {[weak self] cardViewDisplays in
            self?.setupCardViews(cardViewDisplays: cardViewDisplays)
        }.store(in: &cancellables)
        
        viewModel.contentSizeContainer.sink { [weak self] size in
            self?.containerView.contentSize = size
        }.store(in: &cancellables)
    }
    
    private func setupCardViews(cardViewDisplays: [(CardViewModel, CGRect)]){
        for subview in containerView.subviews{
            subview.removeFromSuperview()
        }
        cardViewDisplays.forEach { (cardViewModel, frame) in
            let cardView = CardView(frame: frame, viewModel: cardViewModel)
            cardView.setupBindToPinHeader(to: self)
            self.addSubview(cardView.header)
            containerView.addSubview(cardView)
            cardView.refreshConstrainHeader()

        }
        
    }
        
    private func setupContainerView(){
        containerView.backgroundColor = .white.withAlphaComponent(0)
        containerView.isPagingEnabled = false
        containerView.isScrollEnabled = false
        containerView.showsVerticalScrollIndicator = false
        
    }
       
    private func constraint(){
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15.VAdapted)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
                
            }
        }
    }
    
    //MARK: -Scroll Action
    
    extension BodyContentView{
        
        func viewDidScroll(with scrollView: UIScrollView, and contentOffSetDidScroll: CGFloat){
            let contentOffSet = scrollView.contentOffset.y - contentOffSetDidScroll
            containerView.contentOffset.y = contentOffSet
            for view in containerView.subviews{
                if let cardView = view as? CardView{
                    cardView.pinHeader(contentOffSet: contentOffSet)
                    cardView.changeAlphaColorTopHeader(contentOffset: contentOffSet)
                }
            }
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
            viewModel.checkContentOffsetIsZero(contentOffset: containerView.contentOffset.y)
        }
    }
    
    

