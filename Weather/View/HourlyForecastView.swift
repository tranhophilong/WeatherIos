//
//  HourlyForecastView.swift
//  Weather
//
//  Created by Long Tran on 04/11/2023.
//

import UIKit
import SnapKit


class HourlyForecastView: ViewForCardView {

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    var hourlyForcastItems: [HourlyForecastItem] = []{
        didSet{
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        constraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource  = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.scrollDirection = .horizontal
        collectionView.contentMode = .center
        collectionView.collectionViewLayout = flowLayout
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(HourlyForecastViewCell.self, forCellWithReuseIdentifier: HourlyForecastViewCell.identifier)
    }
    
    private func constraint(){
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    

}


// MARK: - Delegate collectionview

extension HourlyForecastView: UICollectionViewDelegate{
    
}

// MARK: - DataSource collectionview
extension HourlyForecastView: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyForcastItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastViewCell.identifier, for: indexPath) as! HourlyForecastViewCell
        let hourlyForeCastItem = hourlyForcastItems[indexPath.item]
        cell.config(hourlyForecastItem: hourlyForeCastItem)
    
        return cell
    }
    
}

// MARK: - LayoutCell
extension HourlyForecastView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.frame.width / 7) + 10.HAdapted, height: self.frame.height)
    }
}

// MARK: - HourlyforecastCell
class HourlyForecastViewCell: UICollectionViewCell{
    
    static let identifier = "HourlyForecastViewCell"
    private lazy var timeLbl = UILabel(frame: .zero)
    private lazy var iconCondition = UIImageView(frame: .zero)
    private lazy var degreeLbl = UILabel(frame: .zero)
    private lazy var subCondition = UILabel(frame: .zero)
    private lazy var stackView = UIStackView(frame: .zero)
    
    private let font = AdaptiveFont.bold(size: 17.VAdapted)
    private let lblColor: UIColor = .white
    private let subColor: UIColor = .subTitle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        constraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(hourlyForecastItem: HourlyForecastItem){
        timeLbl.text = hourlyForecastItem.time
        iconCondition.image  = hourlyForecastItem.imgCondtion
        subCondition.text = hourlyForecastItem.subCondtion
        degreeLbl.text = hourlyForecastItem.degree
    }
    
    private func layout(){
        
        backgroundColor = .clear
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.alignment = .center
        timeLbl.font = font
        degreeLbl.font = font
        
        timeLbl.textColor = lblColor
        degreeLbl.textColor = lblColor
        subCondition.textColor = .subTitle
        subCondition.font = AdaptiveFont.medium(size: 13.VAdapted)
        
        var stackVerCondition = UIStackView()
        stackVerCondition.axis = .vertical
        stackVerCondition.alignment = .center
        stackVerCondition.distribution = .fillProportionally
    
        iconCondition.contentMode = .center
        iconCondition.tintColor = .white
        
        stackVerCondition.addArrangedSubview(iconCondition)
        stackVerCondition.addArrangedSubview(subCondition)
        
        stackView.addArrangedSubview(timeLbl)
        stackView.addArrangedSubview(stackVerCondition)
        stackView.addArrangedSubview(degreeLbl)
        
  
    }
    
    private func constraint(){
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.VAdapted)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10.VAdapted)
        }
        
        timeLbl.snp.makeConstraints {[weak self] make in
            make.height.equalTo(self!.frame.height * 25/100)
        }

    }
    
}
