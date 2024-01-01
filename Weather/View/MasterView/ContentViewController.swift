//
//  ContentViewController.swift
//  Weather
//
//  Created by Long Tran on 27/11/2023.
//

import UIKit
import SnapKit


protocol ContentViewViewControllerDelegate: AnyObject{
    func dismissSearchResultView(isDismiss: Bool)
    func addContentView(contentView: ContentView)
}

class ContentViewController: UIViewController {
    
    private lazy var btnAdd = UIButton(frame: .zero)
    private lazy var btnCancel = UIButton(frame: .zero)
    private lazy var imgBackground = UIImageView(frame: .zero)
    private let viewModel = ContentViewControllerViewModel()
    weak var delegate: ContentViewViewControllerDelegate?
    private let contentViewModel: ContentViewModel
    private  lazy var contentView = ContentView(frame: .zero, viewModel: contentViewModel)
    
    init(contentViewModel: ContentViewModel){
        self.contentViewModel = contentViewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupContentView()
        constraint()

        btnAdd.addTarget(self, action: #selector(addLocation), for: .touchUpInside)
        btnCancel.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
    }
    
    private func setupContentView(){
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20.VAdapted)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            
        }
    }
    
    @objc private func addLocation(){
        viewModel.addNameLocationCoredata(locationName: title!)
        delegate?.dismissSearchResultView(isDismiss: true)
        delegate?.addContentView(contentView: contentView)
        dismiss(animated: true)
    }
    
    @objc private func dismissView(){
        dismiss(animated: true)
        delegate?.dismissSearchResultView(isDismiss: false)
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
    }

}
