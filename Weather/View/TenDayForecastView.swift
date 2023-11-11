//
//  TenDayForecastView.swift
//  Weather
//
//  Created by Long Tran on 04/11/2023.
//

import UIKit
import SnapKit

struct TenDayForecastItem{
    let iconCondition: UIImage
    let lowDegree: String
    let highDegree: String
    let time: String
    let subCondtion: String
}

class TenDayForecastView: ViewForCardView {

    private let tableView = UITableView(frame: .zero)
    private let numItems = 10
    
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
        tableView.separatorColor = .white
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10.HAdapted, bottom: 0, right: 10.HAdapted)
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
        return numItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TenDayForecastViewCell.identifier, for: indexPath) as! TenDayForecastViewCell
        let item =  TenDayForecastItem(iconCondition: UIImage(systemName: "cloud.sun.rain.fill")!.withRenderingMode(.alwaysTemplate), lowDegree: "24°", highDegree: "30°", time: "Mon", subCondtion: "15%")
        cell.config(item: item)
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
    private lazy var barTemp = UIView(frame: .zero)
    private lazy var pointCurrentDegree = CALayer()
    
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
    
    
    func config(item: TenDayForecastItem){
        timeLbl.text = item.time
        iconCondtion.image =  item.iconCondition
        lowDegreeLbl.text = item.lowDegree
        highDegreeLbl.text = item.highDegree
        subCondition.text = item.subCondtion
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
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
        
//        bar temp
        
        barTemp.backgroundColor = .darkGray
        barTemp.layer.cornerRadius =  5.HAdapted / 2
        
        let cAGradient = CAGradientLayer()
        cAGradient.frame = CGRect(x: 0, y: 0, width: 70.HAdapted , height: 5.VAdapted)
        cAGradient.colors = [UIColor.orangeGradentL.cgColor, UIColor.orangeGradientR.cgColor]
        cAGradient.locations = [0,1]
        cAGradient.cornerRadius = 5.HAdapted/2
        
//        point current degree
        
        pointCurrentDegree.backgroundColor = UIColor.white.cgColor
        pointCurrentDegree.frame = CGRect(x: 20.HAdapted, y: 0, width: 5.HAdapted, height: 5.VAdapted)
        pointCurrentDegree.cornerRadius = 5.HAdapted/2
        pointCurrentDegree.borderColor = UIColor.brightBlue.cgColor
//        pointCurrentDegree.borderWidth = 0.5
        
        
//        add sub view to stack view horizontal
        stackViewHorizontal.addArrangedSubview(timeLbl)
        stackViewHorizontal.addArrangedSubview(stackViewVer)
        stackViewHorizontal.addArrangedSubview(lowDegreeLbl)
        stackViewHorizontal.addArrangedSubview(barTemp)
        stackViewHorizontal.addArrangedSubview(highDegreeLbl)
        
        barTemp.snp.makeConstraints {[weak self] make in
            make.width.equalTo((self!.frame.width - 20.HAdapted) * 35/100)
            make.height.equalTo(5.VAdapted)
        }
        
        stackViewVer.snp.makeConstraints {[weak self] make in
            make.width.equalTo((self!.frame.width - 20) * 40/100)
        }
        barTemp.layer.insertSublayer(cAGradient, at: 0)
        barTemp.layer.insertSublayer(pointCurrentDegree, at: 1)

//
    
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
