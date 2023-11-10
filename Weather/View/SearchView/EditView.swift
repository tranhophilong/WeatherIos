//
//  EditView.swift
//  Weather
//
//  Created by Long Tran on 08/11/2023.
//

import UIKit
import SnapKit
import Combine

struct EditButton{
    let title: String
    let icon: UIImage?
    let showSymbolCell: Bool
    let showSymbollFeh: Bool
    let editFunc: EditFunc
}

enum EditFunc{
    case editList
    case changeToCel
    case changToFah
}

protocol EditViewDelegate: AnyObject{
    func editData()
}

class EditView: UIView, UITableViewDataSource, UITableViewDelegate{
        
    
    let items = [EditButton(title: "Edit", icon: UIImage(systemName: "pencil"), showSymbolCell: false, showSymbollFeh: false, editFunc: .editList),
                 EditButton(title: "Celsius", icon: nil, showSymbolCell: true, showSymbollFeh: false, editFunc: .changeToCel),
                 EditButton(title: "Fehrenheit", icon: nil, showSymbolCell: false, showSymbollFeh: true, editFunc: .changToFah)]
    private lazy var tableView = UITableView(frame: .zero)
    private let mainviewModel = SearchViewModel()
    
    var delegate: EditViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        constraint()
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
    
  
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditCell.identifier, for: indexPath) as! EditCell
        
        cell.config(item: items[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.frame.height / CGFloat(items.count)) + 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        switch item.editFunc{
        case .editList:
            delegate?.editData()
            isHidden = true
        case .changeToCel:
            print("cel")
        case .changToFah:
            print("fah")
        }
    }
    
    
    
    
}
 


//MARK: - EDIT CELL

class EditCell : UITableViewCell{
    static let identifier = "EditCell"
    
    private lazy var titleLbl = UILabel(frame: .zero)
    private lazy var icon = UIImageView(frame: .zero)
    private let symbolCel = UILabel(frame: .zero)
    private let symbolFeh = UILabel(frame: .zero)
    
    
    private let lblFont = AdaptiveFont.medium(size: 17)
    private let lblColor: UIColor = .white
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        constraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(item: EditButton){
        icon.image = item.icon
        if item.showSymbolCell{
            symbolCel.isHidden = false
            icon.isHidden = true
            symbolFeh.isHidden = true
        }else if item.showSymbollFeh{
            symbolCel.isHidden = true
            icon.isHidden = true
            symbolFeh.isHidden = false
        }else{
            symbolCel.isHidden = true
            icon.isHidden = false
            symbolFeh.isHidden = true
        }
        titleLbl.text = item.title
    }
    
    
    private func layout(){
        selectionStyle = .none
        backgroundColor = .darkGray
        titleLbl.font  = lblFont
        titleLbl.textColor = lblColor
        
        symbolCel.text  = "°C"
        symbolFeh.text = "°F"
        symbolCel.font = AdaptiveFont.bold(size: 17.HAdapted)
        symbolFeh.font = AdaptiveFont.bold(size: 17.HAdapted)
        symbolCel.textColor = .white
        symbolFeh.textColor  = .white
        
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        
    }
    private func constraint(){
        addSubview(titleLbl)
        addSubview(icon)
        addSubview(symbolCel)
        addSubview(symbolFeh)
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.VAdapted)
            make.left.equalToSuperview().offset(20.HAdapted)
        }
        
        icon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.VAdapted)
            make.right.equalToSuperview().offset(-15.HAdapted)
        }
        
        symbolCel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.VAdapted)
            make.right.equalToSuperview().offset(-15.HAdapted)
        }
        
        symbolFeh.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.VAdapted)
            make.right.equalToSuperview().offset(-15.HAdapted)
        }
    }
}

