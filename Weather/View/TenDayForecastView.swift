//
//  TenDayForecastView.swift
//  Weather
//
//  Created by Long Tran on 04/11/2023.
//

import UIKit
import SnapKit



class TenDayForecastView: ViewForCardView {
    
    private let tableView = UITableView(frame: .zero)
    private let numItems = 10
    var tenDayForcastItems: ([TenDayForecastItem], [TempBarItem]) = ([],[]){
        didSet{
            tableView.reloadData()
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableview()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableview(){
        tableView.backgroundColor = .clear
        backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(TenDayForecastViewCell.self, forCellReuseIdentifier: TenDayForecastViewCell.identifier)
        
    }
    
    private func constraints(){
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

}
// MARK: - TableView DataScoure
extension TenDayForecastView: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tenDayForcastItems.0.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TenDayForecastViewCell.identifier, for: indexPath) as! TenDayForecastViewCell
        let item =  tenDayForcastItems.0[indexPath.row]
        let tempBarItem = tenDayForcastItems.1[indexPath.row]
        cell.config(item: item, tempBarItem: tempBarItem)
        cell.backgroundColor = .clear
        return cell
    }
    
}

// MARK: - TableView Delegate
extension TenDayForecastView: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.frame.height / 10
    }
}

//MARK: - Ten day Forecast Cell

class TenDayForecastViewCell: UITableViewCell{
    
    static let identifier = "TenDayForecastViewCell"
        
    private lazy var timeLbl = UILabel(frame: .zero)
    private lazy var iconCondtion = UIImageView(frame: .zero)
    private lazy var subCondition = UILabel(frame: .zero)
    private lazy var lowDegreeLbl = UILabel(frame: .zero)
    private lazy var highDegreeLbl = UILabel(frame: .zero)
    private lazy var stackViewHorizontal = UIStackView(frame: .zero)
    private lazy var tempBar = TempBarGradientColorView(frame: .zero)
    
    private lazy var widthTempBar = (frame.width - 25.HAdapted) * 35/100
    private let fontLbl = AdaptiveFont.bold(size: 17.HAdapted)
    private let fontSubCondition = AdaptiveFont.bold(size: 13.HAdapted)
    private let timeColor: UIColor = .white
    private let highDegreeColor: UIColor = .white
    private let lowDegreeColor: UIColor  = .systemGray6
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: TenDayForecastViewCell.identifier)
        constraint()
        layout()
    }
    
    override var frame: CGRect{
        get {
                    return super.frame
            }
                
        set (newFrame) {
            var frame = newFrame
            let newWidth = frame.width - 10.HAdapted
            let space = (frame.width - newWidth) / 2
            frame.size.width = newWidth
            frame.origin.x += space
            super.frame = frame
            
        }
    }
    
    func config(item: TenDayForecastItem, tempBarItem: TempBarItem){
        timeLbl.text = item.time
        iconCondtion.image =  item.iconCondition
        lowDegreeLbl.text =  item.lowDegree + "°"
        highDegreeLbl.text = item.highDegree + "°"
        subCondition.text = item.subCondtion 
        
        tempBar.config(tempBarItem: tempBarItem, widthTempBar: widthTempBar)
       
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        
        let _ =  addSeparator(width: SCREEN_WIDTH() - 80.HAdapted, x: 10.HAdapted, y: 0, to: self)
        
        selectionStyle = .none
        backgroundColor = .clear
        stackViewHorizontal.backgroundColor = .clear
        stackViewHorizontal.spacing = 5.HAdapted
        stackViewHorizontal.axis = .horizontal
        stackViewHorizontal.distribution = .fillProportionally
        stackViewHorizontal.alignment = .center
        
//        font
        timeLbl.font  = fontLbl
        lowDegreeLbl.font = fontLbl
        highDegreeLbl.font = fontLbl
        subCondition.font = fontSubCondition
        
//        text color
        timeLbl.textColor = timeColor
        lowDegreeLbl.textColor = lowDegreeColor
        highDegreeLbl.textColor = highDegreeColor
        subCondition.textColor = .subTitle
        iconCondtion.tintColor = .white
        
        
//        label
        
        lowDegreeLbl.textAlignment = .right

        
//        ConditioniconView
        
        let stackViewVer = UIStackView()
        stackViewVer.spacing = 3.HAdapted
        stackViewVer.backgroundColor = .clear
        stackViewVer.axis = .vertical
        stackViewVer.alignment = .center
        stackViewVer.addArrangedSubview(iconCondtion)
        stackViewVer.addArrangedSubview(subCondition)
        
        
//        add sub view to stack view horizontal
        stackViewHorizontal.addArrangedSubview(timeLbl)
        stackViewHorizontal.addArrangedSubview(stackViewVer)
        stackViewHorizontal.addArrangedSubview(lowDegreeLbl)
        stackViewHorizontal.addArrangedSubview(tempBar)
        stackViewHorizontal.addArrangedSubview(highDegreeLbl)
        
        timeLbl.snp.makeConstraints { make in
            make.width.equalTo(50.HAdapted)
        }
        
        tempBar.snp.makeConstraints {[weak self] make in
            make.width.equalTo(self!.widthTempBar)
            make.height.equalTo(5.VAdapted)
        }
   
        stackViewVer.snp.makeConstraints {[weak self] make in
            make.width.equalTo((self!.frame.width - 20.HAdapted) * 35/100)
        }

    }
    
    private func constraint(){
        addSubview(stackViewHorizontal)
        stackViewHorizontal.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(10.HAdapted)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
  
}
