//
//  SearchResultVCViewController.swift
//  Weather
//
//  Created by Long Tran on 25/11/2023.
//

import UIKit
import Combine
import SnapKit



class SearchResult: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private var cancellabels = Set<AnyCancellable>()
    private var searchResultCellViewModels: [SearchResulCellViewModel] = []
    unowned private let viewModel: SearchResultViewModel
    private var textSearching: String = ""
    private let tableView = UITableView(frame: .zero)
    private let alternativeViewModel = AlternativeViewModel(imgName: "magnifyingglass", title: "No Results")
    private lazy var alterView = AlternativeView(frame: .zero, viewModel: alternativeViewModel)
    
    init(viewModel: SearchResultViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.backgroundColor?.withAlphaComponent(0.8)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
        setupBinderChangeData()
        constraint()
        setupAlterView()
        setupBinderShowAlterView()
        
    }
     
    private func setupAlterView(){
        alterView.bounds = view.bounds
    }
    
    private func setupBinderShowAlterView(){
        viewModel.showAlterView.sink {[weak self] value in
            if value{
                self?.alterView.isHidden = false
                self?.alternativeViewModel.changeSubtitle(text: "No results for \"\(self!.textSearching)\"")
            }else{
                self!.alterView.isHidden =  true

            }
        }.store(in: &cancellabels)
    }
    
    private func setupBinderChangeData(){
        viewModel.searchResultCellViewModels.sink {[weak self] value in
            self!.searchResultCellViewModels = value
            self!.tableView.reloadData()
        }.store(in: &cancellabels)
        
        viewModel.textSearching.sink {[weak self] value in
            self!.textSearching = value
        }.store(in: &cancellabels)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResultCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
        let searchResultCellViewModel = searchResultCellViewModels[indexPath.row]
        cell.viewModel = searchResultCellViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nameLocation = searchResultCellViewModels[indexPath.row].place.value
        let contentViewModel = ContentViewModel(nameLocation: nameLocation, coordinate: nil)
        viewModel.presentContentViewController.send(contentViewModel)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.VAdapted
    }
    
    private func constraint(){
        view.addSubview(tableView)
        view.addSubview(alterView)
        
        alterView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50.VAdapted)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}



fileprivate class SearchResultCell: UITableViewCell{
    
    private lazy var label = UILabel(frame: .zero)
    static let identifier = "SearchResultCell"
    private var cancellables = Set<AnyCancellable>()
    var viewModel: SearchResulCellViewModel!{
        didSet{
            setupBinder()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "SearchResultCell")
        setupView()
        constraint()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBinder(){
        viewModel.place.sink {[weak self] value in
            self?.label.text = value
        }.store(in: &cancellables)
        
        viewModel.placeSearching.sink {[weak self] value in
            self?.highlightSearch(searchString: value, resultString: self!.label.text ?? "")
        }.store(in: &cancellables)
        
    }
    
    private func setupView(){
        selectionStyle = .none
        backgroundColor = .black
        label.font = AdaptiveFont.medium(size: 16.HAdapted)
        label.textColor = .white.withAlphaComponent(0.7)
    }
    
   private func highlightSearch(searchString: String, resultString: String)   {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: resultString)
        let Desiredpattern = searchString.lowercased()
        let range: NSRange = NSMakeRange(0, resultString.count)

        let regex = try! NSRegularExpression(pattern: Desiredpattern, options: NSRegularExpression.Options())

        regex.enumerateMatches(in: resultString.lowercased(), options: NSRegularExpression.MatchingOptions(), range: range) { (textCheckingResult, matchingFlags, stop) -> Void in
            let Range = textCheckingResult?.range
            attributedString.addAttribute(NSAttributedString.Key.font, value: AdaptiveFont.bold(size: 16.HAdapted), range: Range!)
            attributedString.addAttribute(.foregroundColor, value: UIColor.white.withAlphaComponent(1), range: Range!)
        }

        label.attributedText = attributedString
    }
    
    private func constraint(){
        addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20.HAdapted)
        }
    }
}



