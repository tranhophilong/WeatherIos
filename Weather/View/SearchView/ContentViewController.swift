//
//  ContentViewController.swift
//  Weather
//
//  Created by Long Tran on 27/11/2023.
//

import UIKit
import SnapKit
import Combine

class ContentViewController: UIViewController {
    
    private lazy var btnAdd = UIButton(frame: .zero)
    private lazy var btnCancel = UIButton(frame: .zero)
    private lazy var imgBackground = UIImageView(frame: .zero)
    private  lazy var contentView = ContentView(frame: .zero, viewModel: viewModel.contentViewModel)
    let viewModel: ContentViewControllerViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ContentViewControllerViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        constraint()
        setupBinder()

        btnAdd.addTarget(self, action: #selector(addLocation), for: .touchUpInside)
        btnCancel.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
    }
    
    private func setupBinder(){
        viewModel.isHiddenAddBtn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isHidden in
            self!.btnAdd.isHidden = isHidden
        }.store(in: &cancellables)
    }
    
    
    @objc private func addLocation(){
 
        viewModel.addContentWeather.send(true)
        
    }
    
    @objc private func dismissView(){
        viewModel.isCancelContentVC.send(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.isCancelContentVC.send(true)

    }
    
    
    private func setupViews(){
        btnAdd.setTitle("Add", for: .normal)
        btnAdd.setTitleColor(.white, for: .normal)
        btnAdd.titleLabel?.font = AdaptiveFont.bold(size: 16)
        
        btnCancel.setTitleColor(.white, for: .normal)
        btnCancel.setTitle("Cancel", for: .normal)
        btnCancel.titleLabel?.font = AdaptiveFont.bold(size: 16)
       
        imgBackground.image = UIImage(named: "blue-sky2.jpeg")
        imgBackground.contentMode = .scaleAspectFill
        
    }

    private func constraint(){
        
        view.addSubview(imgBackground)
        view.addSubview(btnAdd)
        view.addSubview(btnCancel)
        view.addSubview(contentView)
        
        btnAdd.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-10.HAdapted)
        }
        
        btnCancel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(10.HAdapted)
        }
        
        imgBackground.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        
        contentView.snp.makeConstraints {[weak self] make in
            make.top.equalTo(self!.btnCancel.snp.bottom).offset(20.VAdapted)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(SCREEN_HEIGHT())
        }
        
        contentView.event.send(.scroll(contentOffSet: -44, bodyContentOffSetIsZero: true, heightHeaderContent: 350.VAdapted))
    }

}
