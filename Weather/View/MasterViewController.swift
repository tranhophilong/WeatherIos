//
//  WeatherViewController.swift
//  Weather
//
//  Created by Long Tran on 21/10/2023.
//

import UIKit
import SnapKit

class MasterViewController: UIViewController {

    private lazy var containerView  = UIScrollView(frame: .zero)
    private lazy var bottomAppBarView = BottomAppBarView(frame: .zero)
    var numberSubviews: Int = 3
    private lazy var widthContent: CGFloat = self.view.bounds.width
    private lazy var heightContent: CGFloat = self.view.bounds.height
    private var currentXContainer: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
        setupBottomAppBar()
        constraint()
    }
    
    
    private func setupContainerView(){
        containerView.backgroundColor = .greyGrade
        containerView.contentSize = CGSize(width: widthContent * CGFloat(numberSubviews), height: heightContent)
        containerView.isPagingEnabled = true
        containerView.showsHorizontalScrollIndicator = false
        containerView.delegate = self
        
        
        for i in 0..<numberSubviews{
            let view = ContentView(frame: CGRectMake(CGFloat(i) * widthContent, 0, widthContent, heightContent), title: "view\(i)")
            containerView.addSubview(view)
        }
    }
    
    private func setupBottomAppBar(){
        bottomAppBarView.numberPageControll =  numberSubviews
        
    }
    
    private func constraint(){
        view.addSubview(containerView)
        view.addSubview(bottomAppBarView)
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        bottomAppBarView.snp.makeConstraints { make in
            make.height.equalTo(80.VAdapted)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}


//MARK: scroll action

extension MasterViewController: UIScrollViewDelegate{
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentXContainer >= scrollView.contentOffset.x{
            bottomAppBarView.currentPage = Int( ceil((scrollView.contentOffset.x  * CGFloat(numberSubviews) / scrollView.contentSize.width) - 0.5 ))
        }else{
            bottomAppBarView.currentPage = Int((scrollView.contentOffset.x  * CGFloat(numberSubviews) / scrollView.contentSize.width) + 0.5)
        }
        currentXContainer = scrollView.contentOffset.x

    }
    
  
}
