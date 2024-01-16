//
//  AlternativeView.swift
//  Weather
//
//  Created by Long Tran on 27/11/2023.
//

import UIKit
import SnapKit
import Combine

class AlternativeView: UIView {
    
    private lazy var image = UIImageView(frame: .zero)
    private lazy var title = UILabel(frame: .zero)
    private lazy var subTitle = UILabel(frame: .zero)
    unowned private let viewModel: AlternativeViewModel
    private var cancellables = Set<AnyCancellable>()

    public init(frame: CGRect, viewModel: AlternativeViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupViews()
        setupBinder()
        constraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func setupBinder(){
        
        viewModel.imageName.sink {[weak self] imgName in
            self?.image.image = UIImage(systemName: imgName)?.withRenderingMode(.alwaysTemplate)
        }.store(in: &cancellables)
        
        viewModel.title.sink {[weak self] title in
            self?.title.text = title
        }.store(in: &cancellables)
        
        viewModel.subTitle.sink { [weak self] subTitle in
            self?.subTitle.text = subTitle
        }.store(in: &cancellables)
    }
    
    private func setupViews(){
        image.contentMode = .scaleAspectFill
        image.tintColor = .gray
        
        
        title.textColor = .white
        subTitle.textColor = .gray
        
        title.font = AdaptiveFont.bold(size: 20)
        subTitle.font = AdaptiveFont.medium(size: 16)
        
        title.textAlignment = .center
        
        subTitle.numberOfLines = 0
        subTitle.textAlignment = .center
        subTitle.lineBreakMode = .byWordWrapping
      
    }
    
    private func constraint(){
        
        addSubview(image)
        addSubview(title)
        addSubview(subTitle)
        
        image.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50.VAdapted)
            make.size.equalTo([70, 70].HResized)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(15.VAdapted)
            make.centerX.equalToSuperview()
        }
        
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(20.VAdapted)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }

}
