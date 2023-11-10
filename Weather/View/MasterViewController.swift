//
//  WeatherViewController.swift
//  Weather
//
//  Created by Long Tran on 21/10/2023.
//

import UIKit
import SnapKit
import Combine

class MasterViewController: UIViewController {

    private lazy var containerView  = UIScrollView(frame: .zero)
    private lazy var bottomAppBarView = BottomAppBarView(frame: .zero)
    private lazy var backGroundImg = UIImageView(frame: .zero)
    private let viewModel = MasterViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
        setupBottomAppBar()
        constraint()
        setupBinder()
    }
    
    
    private func setupBinder(){
        viewModel.numberSubviews.sink {[weak self] num in
            for i in 0..<num{
                let view = ContentView(frame: CGRectMake(CGFloat(i) * self!.viewModel.contentSize.width, 0, self!.viewModel.contentSize.width, self!.viewModel.contentSize.height), title: "view\(i)")
                self!.containerView.addSubview(view)
            }
        }.store(in: &cancellables)
        
        
        
        viewModel.currentPageControl.sink {[weak self] index in
            self!.bottomAppBarView.currentPage = index
        }.store(in: &cancellables)
        
    }
    
    
    private func setupContainerView(){
        containerView.backgroundColor = .clear
        containerView.contentSize = CGSize(width: viewModel.contentSize.width * CGFloat(viewModel.numberSubviews.value), height: viewModel.contentSize.height)
        containerView.isPagingEnabled = true
        containerView.showsHorizontalScrollIndicator = false
        containerView.delegate = self
        

    }
    
    private func setupBottomAppBar(){
        bottomAppBarView.numberPageControll =  viewModel.numberSubviews.value
        
    }
    
    private func constraint(){
        
        view.addSubview(backGroundImg)
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
         
        backGroundImg.image = UIImage(named: "blue-sky2.jpeg")
        backGroundImg.contentMode = .scaleAspectFill
        backGroundImg.clipsToBounds = true
        
        backGroundImg.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}


//MARK: -scroll action

extension MasterViewController: UIScrollViewDelegate{
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        viewModel.changePageControl(with: scrollView.contentOffset.x)
    }
    

}
