//
//  EditView.swift
//  Weather
//
//  Created by Long Tran on 08/11/2023.
//

import UIKit
import SnapKit
import Combine



class EditView: UIView, UITableViewDataSource, UITableViewDelegate{
        
    private lazy var tableView = UITableView(frame: .zero)
    unowned   private let viewModel: EditViewModel
    private var editCellViewModels = [EditCellViewModelProtocol]()
    private var cancellables = Set<AnyCancellable>()
        
    public init(frame: CGRect, viewModel: EditViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupTableView()
        constraint()
        setupBinder()
        viewModel.getEditCellViewModels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    private func setupTableView(){
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .white
        tableView.isScrollEnabled = false
        tableView.register(EditCell.self, forCellReuseIdentifier: EditCell.identifier)
    }
    
    private func constraint(){
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupBinder(){
        viewModel.editCellViewModels.sink {[weak self] editCellViewModels in
            self?.editCellViewModels = editCellViewModels
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditCell.identifier, for: indexPath) as! EditCell
        cell.viewModel = editCellViewModels[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.frame.height / CGFloat(editCellViewModels.count)) + 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editCellViewModel = editCellViewModels[indexPath.row]
        
        if let editCellViewModel = editCellViewModel as? EditCellCelsiusViewModel{
            viewModel.delegate?.changeToCel()
        }
        
        if let editCellViewModel = editCellViewModel as? EditCellFahrenheitViewModel{
            viewModel.delegate?.changeToFah()
        }
        
        if let editCellViewModel = editCellViewModel as? EditCellEditListWeatherCellViewModel{
            viewModel.delegate?.editListWeatherCell()
        }
    }
    
}

//MARK: - EDIT CELL

fileprivate class EditCell : UITableViewCell{
    static let identifier = "EditCell"
    
    private lazy var titleLbl = UILabel(frame: .zero)
    private lazy var symbolImg = UIImageView(frame: .zero)
    private lazy var symbolText = UILabel(frame: .zero)
    private let lblFont = AdaptiveFont.medium(size: 17)
    private let lblColor: UIColor = .white
    var viewModel: EditCellViewModelProtocol!{
        didSet{
            titleLbl.text = viewModel.title
            symbolText.text = viewModel.symbolText
            symbolImg.image = UIImage(systemName: viewModel.nameIcon ?? "")
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        constraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews(){
        selectionStyle = .none
        backgroundColor = .darkGray
        titleLbl.font  = lblFont
        titleLbl.textColor = lblColor
    
        symbolImg.tintColor = .white
        symbolImg.contentMode = .scaleAspectFit
        
        symbolText.font = AdaptiveFont.bold(size: 17.HAdapted)
        symbolText.textColor = .white
        
    }
    private func constraint(){
        addSubview(titleLbl)
        addSubview(symbolImg)
        addSubview(symbolText)
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.VAdapted)
            make.left.equalToSuperview().offset(20.HAdapted)
        }
        
        symbolImg.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.VAdapted)
            make.right.equalToSuperview().offset(-15.HAdapted)
        }
        
        symbolText.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.VAdapted)
            make.right.equalToSuperview().offset(-15.HAdapted)
        }
        
    }
}

