//
//  SearchViewController.swift
//  Weather
//
//  Created by Long Tran on 06/11/2023.
//

import UIKit
import SnapKit
import Combine
import GooglePlaces
import CoreData
import CoreLocation




class SearchViewController: UIViewController, UISearchResultsUpdating, UITextFieldDelegate {
    
    private lazy var editView = EditView(frame: .zero, viewModel: editViewModel)
    private lazy var largeTitle = UILabel(frame: .zero)
    private lazy var tableView = UITableView(frame: .zero)
    private var animationView : UIView!
    private var imgAnimatedContentView: UIImageView!
    private lazy var searchResult = SearchResult(viewModel: searchResultViewModel)
    private lazy var blurView: UIView = {
        let containerView = UIView()
        let dimmedView = UIView()
        dimmedView.backgroundColor = .black.withAlphaComponent(0.3)
        dimmedView.frame = self.view.bounds
        containerView.addSubview(dimmedView)
        view.addSubview(containerView)
        
        return containerView
    }()
    
    private let editViewModel = EditViewModel()
    let searchResultViewModel = SearchResultViewModel()
    private var imgContents: [UIImage]?
    var animationCellIndex: Int?
    var isForecastCurrentWeather: Bool = false
    let viewModel: SearchViewControllerViewModel
    private var cancellabels = Set<AnyCancellable>()
    let event = PassthroughSubject<SearchViewControllerViewModel.EventInput, Never>()
    private let locationManager = CLLocationManager()
    private var heighEditViewConstraint: Constraint?
    private var widthEditViewConstraint: Constraint?
    private var weatherCellViewModels = [WeatherCellViewModel]()
    
    init(viewModel: SearchViewControllerViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        setupNavigationController()
        setupNavigationController()
        setupSearchBar()
        constraint()
        setupEditView()
        setupTableView()
        setupBinder()
        setupAnimatedView()
        event.send(.viewDidLoad)
    }
    
    private func setupView(){
        self.navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .black
    }
    
    private func setupAnimatedView(){
        
        guard  let animationCellIndex = animationCellIndex, let imgContent = imgContents?[animationCellIndex] else{
            return
        }
        
        animationView  = UIView()
        animationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        animationView.layer.cornerRadius = 15.HAdapted
        animationView?.backgroundColor = .brightBlue
        
        imgAnimatedContentView = UIImageView()
        imgAnimatedContentView.contentMode = .center
        imgAnimatedContentView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height )
        imgAnimatedContentView.layer.cornerRadius = 15.HAdapted
        imgAnimatedContentView.image = imgContent
        
        animationView.addSubview(imgAnimatedContentView)
        self.navigationController?.view.addSubview(animationView)
    }
    
    func setImgContentView(imgContentViews: [UIImage]){
        self.imgContents = imgContentViews
        self.tableView.reloadData()
    }
    
    private func setupBinder(){
        viewModel.transform(input: event.eraseToAnyPublisher())
            .receive(on: DispatchQueue.main)
            .sink {[weak self] output in
                switch output{
                case .fetchDataFail:
                    print("fail")
                case .fetchSuccessWeatherCellViewModels(weatherCellViewModels: let weatherCellViewModels):
                    self?.weatherCellViewModels = weatherCellViewModels
                    self?.tableView.reloadData()
                    for weatherCellViewModel in self!.weatherCellViewModels{
                        weatherCellViewModel.hiddenConditionHighLowLbl(is: self!.tableView.isEditing)
                    }
                case .isForecastCurrentWeather(isForecast: let isForecast):
                    self?.isForecastCurrentWeather = isForecast
                    self?.tableView.reloadData()
                case .isHiddenEditView(isHidden: let isHidden):
                    self?.editView.isHidden = isHidden
                    if isHidden{
                        self!.navigationController?.navigationBar.topItem?.rightBarButtonItems![1].tintColor = .white
                    }else{
                        self!.navigationController?.navigationBar.topItem?.rightBarButtonItems![1].tintColor = .darkGray
                    }
                case .isEditMode(isEdit: let isEdit):
                    self?.changeHeightCell()
                    if isEdit{
                        self!.tableView.isEditing = true
                        self!.navigationController?.navigationBar.topItem?.rightBarButtonItems![0].isHidden = false
                        self!.navigationController?.navigationBar.topItem?.rightBarButtonItems![1].isHidden = true
                    }else{
                        self!.tableView.isEditing = false
                        self!.navigationController?.navigationBar.topItem?.rightBarButtonItems![0].isHidden = true
                        self!.navigationController?.navigationBar.topItem?.rightBarButtonItems![1].isHidden = false
                    }
                    self?.tableView.reloadData()
                    self?.tableView.layoutSubviews()
                    for weatherCellViewModel in self!.weatherCellViewModels{
                        weatherCellViewModel.hiddenConditionHighLowLbl(is: isEdit)
                    }
                
                case .isDeactiveSearch(isDeactive: let isDeactive):
                    self?.navigationItem.searchController?.isActive = !isDeactive
                case .isForecastCurrentLocationWeather(isForecast: let isForecast):
                    self?.isForecastCurrentWeather = isForecast
                }
            }.store(in: &cancellabels)
    }
    
    private func setupTableView(){
        tableView.backgroundColor = .black
        tableView.dropDelegate = self
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        tableView.separatorColor = .black
        tableView.backgroundView?.layer.cornerRadius = 15.HAdapted
        tableView.layer.cornerRadius = 20.HAdapted
        tableView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0)
        tableView.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.identifier)
        //        tableView.edit = UIEditingInteractionConfiguration
        
    }
    
    private func setupNavigationController(){
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .gray2
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        
        let appearanceScroll = UINavigationBarAppearance()
        appearanceScroll.configureWithOpaqueBackground()
        appearanceScroll.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        appearanceScroll.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        appearanceScroll.backgroundColor = .black
        navigationController?.navigationBar.scrollEdgeAppearance =  appearanceScroll
        
        let searchController = UISearchController(searchResultsController: searchResult)
        searchController.delegate = self
        let editItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))?.withRenderingMode(.automatic), style: .plain, target: self, action: #selector(changeHiddenStateEditView))
        
        editItem.tintColor = .white
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneEdit))
        doneBtn.tintColor = .white
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.topItem?.rightBarButtonItems = [ doneBtn ,editItem]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "Weather"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationItem.titleView?.tintColor = .white
        self.definesPresentationContext = true
        
    }
    
    private func setupSearchBar(){
        navigationItem.searchController?.searchBar.searchTextField.backgroundColor = .gray2
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.searchController?.searchBar.tintColor = .white
        navigationItem.searchController?.searchBar.searchTextField.textColor = .white
        navigationItem.searchController?.searchBar.searchTextField.tintColor = .white
        navigationItem.searchController?.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search for a city or airport", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        navigationItem.searchController?.searchBar.searchTextField.leftView?.tintColor = .lightGray
        navigationItem.searchController?.searchBar.searchTextField.rightView?.tintColor = .lightGray
        
        navigationItem.searchController?.searchBar.searchTextField.delegate = self
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupEditView(){
        
        editView.layer.cornerRadius = 15.HAdapted
        editView.backgroundColor = .red
        editView.clipsToBounds = true
        editView.isHidden = true
        editViewModel.delegate = viewModel
    }
    
    private func constraint(){
        
        view.addSubview(tableView)
        self.navigationController?.view.addSubview(editView)
        
        editView.snp.makeConstraints {[weak self] make in
            make.top.equalToSuperview().offset(80.VAdapted)
            make.right.equalToSuperview().offset(-20.HAdapted)
            make.width.equalTo(self!.view.frame.width / 2)
            make.height.equalTo(120.VAdapted)
        }
        
        tableView.snp.makeConstraints {  make in
            make.top.equalToSuperview().offset(100.VAdapted)
            make.left.equalToSuperview().offset(15.HAdapted)
            make.right.equalToSuperview().offset(-15.HAdapted)
            make.bottom.equalToSuperview()
        }
        
    }
    
    //    MARK: - Event search
    
    func updateSearchResults(for searchController: UISearchController) {
        
        self.view.addSubview(blurView)
        guard let text = searchController.searchBar.text else{
            return
        }
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
    
        searchResultViewModel.updateSearch(text: text)
        
    }
    
}




//    MARK: - Search controller delegate

extension SearchViewController: UISearchControllerDelegate{
    func didDismissSearchController(_ searchController: UISearchController) {
        blurView.removeFromSuperview()
    }
 
}


// MARK: -  Datasource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.identifier, for: indexPath) as! WeatherCell
        let weatherCellViewModel = weatherCellViewModels[indexPath.row]
        cell.viewModel = weatherCellViewModel
        cell.overrideUserInterfaceStyle = .dark
        return cell
    }
    
//    MARK: - Delegate TABLEVIEW
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.isEditing {
            return 85.VAdapted
        }else{
            return 120.VAdapted
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if isForecastCurrentWeather{
            if indexPath.row == 0{
                return false
            }else{
                return true
            }
        }else{
            return true
        }
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if isForecastCurrentWeather{
            if indexPath.row == 0{
                return false
            }else{
                return true
            }
        }else{
            return true
        }

    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        event.send(.reorderLocation(sourcePosition: Int16(sourceIndexPath.row), destinationPosition: Int16(destinationIndexPath.row)))
    }
    
    

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions = [UIContextualAction]()
        let delete = UIContextualAction(style: .normal, title: nil) { [weak self] (contextualAction, view, completion) in
            self?.event.send(.removeLocation(index: indexPath.row))
            completion(true)
        }
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 15.0, weight: .heavy, scale: .large)
        delete.image = UIImage(systemName: "trash", withConfiguration: largeConfig)?.withTintColor(.white, renderingMode: .alwaysTemplate).addBackgroundCircle(.red)
        delete.backgroundColor = .black
        actions.append(delete)
        let config = UISwipeActionsConfiguration(actions: actions)
        
        return config
    }
    
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row == 0 {
               return sourceIndexPath
           }
      
        
           return proposedDestinationIndexPath
    }
    
   private func changeHeightCell(){
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        setupAnimatedView()
//       
//        
//        guard animationView != nil else{
//            dismiss(animated: true)
//            return
//        }
//        
//        let rectCell = tableView.ts_rectFromParent(at: indexPath)
//        animationView.frame = rectCell
//        animationView.backgroundColor = .clear
//        
//        imgAnimatedContentView.image = imgContents?[indexPath.row]
//        imgAnimatedContentView.frame = CGRect(x: 0, y: 0, width: rectCell.width, height: rectCell.height)
//        imgAnimatedContentView.contentMode = .scaleAspectFit
//        imgAnimatedContentView.alpha = 0
//        
//        
//        let backgroundImgView = UIImageView()
//        backgroundImgView.frame = CGRect(x: 0, y: 0, width: rectCell.width, height: rectCell.height)
//        backgroundImgView.contentMode = .scaleAspectFit
//        backgroundImgView.image = UIImage(named: "sky3.jpeg")
//        backgroundImgView.layer.cornerRadius = 15.HAdapted
//        backgroundImgView.alpha = 0
//        animationView.insertSubview(backgroundImgView, belowSubview: imgAnimatedContentView)
//        self.navigationController?.view.addSubview(animationView)
//        
//        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) { [weak self] in
//            self!.animationView.frame = CGRect(x: 0, y: 0, width: self!.view.frame.width, height: self!.view.frame.height)
//            self!.imgAnimatedContentView.frame = CGRect(x: 0, y: 0, width: self!.view.frame.width, height: self!.view.frame.height)
//            backgroundImgView.frame = CGRect(x: 0, y: 0, width: self!.animationView.frame.width, height: self!.animationView.frame.height)
//            backgroundImgView.alpha = 1
//            self!.imgAnimatedContentView.alpha = 1
//            
//        }completion: {[weak self]  _ in
//          
//            self!.dismiss(animated: false)
//        }
//        
       
        viewModel.backToMasterVC.send(indexPath.row)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard  animationView != nil, imgAnimatedContentView != nil else{
            return
        }
        
        guard let cell = cell as? WeatherCell else{
            return
        }
     
        
        if indexPath.row == animationCellIndex && indexPath.section == 0{
            let rectCell = tableView.ts_rectFromParent(at: indexPath)
            animationView.addSubview(cell.contentView)
//            cell.setBackgroundClear(is: true)
            
//            UIView.animate(withDuration: 0.1) {[weak self] in
//                self!.imgAnimatedContentView.alpha = 0
//
//            }completion: { _ in
//                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {[weak self] in
////                    self?.collapsedView.layoutSubviews()
//                    self?.animatedView.frame.size = rectCell.size
//                    self?.animatedView.frame.origin = rectCell.origin
//                    self?.animatedView.alpha = 0.8
//                }completion: { [weak self] finished in
//                    if finished{
//                        
//                        cell.refreshBackground()
//                        cell.addSubview(cell.contentView)
//                        self?.animatedView.removeFromSuperview()
//                        self?.animatedView = nil
//                    }
//                }
//            }
            
        }
    }
    
    
  
}
// MARK: - Drag and drop Delegate

extension SearchViewController: UITableViewDragDelegate{
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
            dragItem.localObject = weatherCellViewModels[indexPath.row]
            return [ dragItem ]
    }
    
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
            let param = UIDragPreviewParameters()
            param.backgroundColor = .clear
            
            return param
    }
        
}

extension SearchViewController: UITableViewDropDelegate{
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
      
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {

            if session.localDragSession != nil { // Drag originated from the same app.
                return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }

            return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
        }
    
    func tableView(_ tableView: UITableView, dropPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters?{
        let param = UIDragPreviewParameters()
        param.backgroundColor = .clear
        
        return param
    }
}


// MARK: - Edit Event
extension SearchViewController{
    @objc private func doneEdit(){
        event.send(.hiddenEditView)
        event.send(.changeStateEditMode(isEdit: false))
    }
    
    @objc private func changeHiddenStateEditView(){
        event.send(.changeHiddenStateEditView)
       
    }
}



