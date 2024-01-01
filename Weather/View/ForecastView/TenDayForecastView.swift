//
//  TenDayForecastView.swift
//  Weather
//
//  Created by Long Tran on 04/11/2023.
//

import UIKit
import SnapKit
import Combine


class TenDayForecastView: UIView {
    
    private let tableView = UITableView(frame: .zero)
    private let viewModel: TenDayForecastViewModel
    private var tendayForecastCellViewModels: [TenDayForecastCellViewModel] = []
    private var tempBarViewModels: [GradientColorViewModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    
    public init(frame: CGRect, viewModel: TenDayForecastViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupTableview()
        constraints()
        setupBinder()
        viewModel.createCellViewModels()
    }
    
    private func setupBinder(){
        viewModel.cellViewModels.sink {[weak self] (tendayForecastCellViewModels, tempBarViewModels) in
            self!.tendayForecastCellViewModels = tendayForecastCellViewModels
            self!.tempBarViewModels = tempBarViewModels
            self!.tableView.reloadData()
        }.store(in: &cancellables)
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
        return tendayForecastCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TenDayForecastViewCell.identifier, for: indexPath) as! TenDayForecastViewCell
        cell.viewModel = tendayForecastCellViewModels[indexPath.row]
        cell.tempBarViewModel = tempBarViewModels[indexPath.row]

        return cell
    }
    
}

// MARK: - TableView Delegate
extension TenDayForecastView: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.frame.height / CGFloat(tendayForecastCellViewModels.count)
    }
}

//MARK: - Ten day Forecast Cell

fileprivate class TenDayForecastViewCell: UITableViewCell{
    
    static let identifier = "TenDayForecastViewCell"
        
    private lazy var timeLbl = UILabel(frame: .zero)
    private lazy var iconCondtion = UIImageView(frame: .zero)
    private lazy var subCondition = UILabel(frame: .zero)
    private lazy var lowDegreeLbl = UILabel(frame: .zero)
    private lazy var highDegreeLbl = UILabel(frame: .zero)
    private lazy var stackViewHorizontal = UIStackView(frame: .zero)
    private lazy var tempBar = GradientColorView(frame: .zero)
    
    private lazy var widthTempBar = (frame.width - 25.HAdapted) * 35/100
    private let fontLbl = AdaptiveFont.bold(size: 17.HAdapted)
    private let fontSubCondition = AdaptiveFont.bold(size: 13.HAdapted)
    private let timeColor: UIColor = .white
    private let highDegreeColor: UIColor = .white
    private let lowDegreeColor: UIColor  = .systemGray6
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: TenDayForecastViewCell.identifier)
        constraint()
        setupViews()
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
    
    var viewModel: TenDayForecastCellViewModel!{
        didSet{
            timeLbl.text = viewModel.time
            iconCondtion.image =  viewModel.iconCondition
            lowDegreeLbl.text =  viewModel.lowDegree + "°"
            highDegreeLbl.text = viewModel.highDegree + "°"
            subCondition.text = viewModel.subCondtion
        }
    }
    
    var tempBarViewModel: GradientColorViewModel!{
        didSet{
            tempBar.viewModel = tempBarViewModel
           
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setupViews(){
        
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
