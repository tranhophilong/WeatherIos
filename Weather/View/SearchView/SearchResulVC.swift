//
//  SearchResultVCViewController.swift
//  Weather
//
//  Created by Long Tran on 25/11/2023.
//

import UIKit
import Combine
import SnapKit


protocol SearchResulDelegate: AnyObject{
    func deactiveSearch()
    func addContentView(contentView: ContentView)
}

class SearchResult: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private var cancellabels = Set<AnyCancellable>()
    private var places: [String] = []
    private let viewModel = SearchResultViewModel()
    private var textSearching: String = ""
    var delegate: SearchResulDelegate?
    private let tableView = UITableView(frame: .zero)
    private lazy var alterView = AlternativeView(frame: .zero)
    
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
        alterView.setImage(img: UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate))
        alterView.setTitle(text: "No Result")
    }
    
    
    private func setupBinderShowAlterView(){
        viewModel.showAlterView.sink {[weak self] value in
            if value{
                self!.alterView.isHidden = false
                self!.alterView.setSubTitle(text: "No results for \"\(self!.textSearching)\"")
            }else{
                self!.alterView.isHidden =  true

            }
        }.store(in: &cancellabels)
    }
    
    private func setupBinderChangeData(){
        viewModel.places.sink {[weak self] value in
            self!.places = value
            self!.tableView.reloadData()
        }.store(in: &cancellabels)
    }
    
    func updateSearch(text: String){
        viewModel.getPlaces(query: text)
        textSearching = text
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
        let text = places[indexPath.row]
        cell.setText(text: text)
        cell.highlightSearch(searchString: textSearching, resultString: text)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let contentVC = ContentViewController()
        contentVC.title = places[indexPath.row]
        contentVC.delegate = self
        present(contentVC, animated: true)
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

extension SearchResult: ContentViewViewControllerDelegate{
    func addContentView(contentView: ContentView) {
        delegate?.addContentView(contentView: contentView)
    }
    
    func dismissSearchResultView(isDismiss: Bool) {
        
        if isDismiss{
            delegate?.deactiveSearch()
        }
    }
 
}

class SearchResultCell: UITableViewCell{
    
    private lazy var label = UILabel(frame: .zero)
    static let identifier = "SearchResultCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "SearchResultCell")
        layout()
        constraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(text: String){
        label.text = text
    }
    
    private func layout(){
        selectionStyle = .none
        backgroundColor = .black
        label.font = AdaptiveFont.medium(size: 16.HAdapted)
        label.textColor = .white.withAlphaComponent(0.7)
    }
    
    func highlightSearch(searchString: String, resultString: String)   {
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



