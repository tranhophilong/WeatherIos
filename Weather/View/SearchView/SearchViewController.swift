//
//  SearchViewController.swift
//  Weather
//
//  Created by Long Tran on 06/11/2023.
//

import UIKit
import SnapKit
import Combine



class SearchResult: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}

class SearchViewController: UIViewController, UISearchResultsUpdating, UITextFieldDelegate {
    
    
    
    private lazy var editView = EditView(frame: .zero)
    private let mainViewModel = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var heighEditViewConstraint: Constraint?
    private var widthEditViewConstraint: Constraint?

    
    private var weatherItems = [WeatherItem(location: "Ho Chi Minh", time: "10:00", condtion: "cloudy", lowDegree: "22", highDegree: "30", currentDegree: "27", background: UIImage(named: "blue-sky2.jpeg")!),
                                WeatherItem(location: "Ha Noi", time: "10:00", condtion: "Rain", lowDegree: "22", highDegree: "30", currentDegree: "27", background: UIImage(named: "rain-sky.jpeg")!),
                                WeatherItem(location: "Da Nang", time: "10:00", condtion: "Rain", lowDegree: "22", highDegree: "30", currentDegree: "27", background: UIImage(named: "rain-sky.jpeg")!),
                                WeatherItem(location: "Da Nang", time: "10:00", condtion: "Rain", lowDegree: "22", highDegree: "30", currentDegree: "27", background: UIImage(named: "rain-sky.jpeg")!)]
    
    private lazy var largeTitle = UILabel(frame: .zero)
    private lazy var tableView = UITableView(frame: .zero)
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupSearchBar()
        constraint()
        layout()
        setupTableView()
        setupBinderToChangeSateView()
        
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
        editView.delegate = self
    }
    
   
    private func setupBinderToChangeSateView(){
        
//        Change state right bar button items
        mainViewModel.isEditDataWeather.sink {[weak self] value in
            if value{
                
                self!.tableView.isEditing = true
                self!.navigationController?.navigationBar.topItem?.rightBarButtonItems![0].isHidden = false
                self!.navigationController?.navigationBar.topItem?.rightBarButtonItems![1].isHidden = true
            }else{
                self!.tableView.isEditing = false
                self!.navigationController?.navigationBar.topItem?.rightBarButtonItems![0].isHidden = true
                self!.navigationController?.navigationBar.topItem?.rightBarButtonItems![1].isHidden = false
            }
    
        }.store(in: &cancellables)
        
        mainViewModel.isShowEditView.sink {[weak self] value in
            if value{
                self!.navigationController?.navigationBar.topItem?.rightBarButtonItems![1].tintColor = .darkGray
//                show editView
                UIView.animate(withDuration: 1, delay: 10, options: UIView.AnimationOptions.curveLinear) {
                    self!.widthEditViewConstraint?.update(offset: self!.view.frame.width / 2)
                    self!.heighEditViewConstraint?.update(offset: 120.VAdapted)
                }
            }else{
                self!.navigationController?.navigationBar.topItem?.rightBarButtonItems![1].tintColor = .white
//                hidden editView
                UIView.animate(withDuration: 1, delay: 10, options: UIView.AnimationOptions.curveLinear) {
                    self!.widthEditViewConstraint?.update(offset: 0)
                    self!.heighEditViewConstraint?.update(offset: 0)
                }
                
            }
        }.store(in: &cancellables)
    }
    
    private func setupTableView(){
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
        tableView.register(WeatherViewCell.self, forCellReuseIdentifier: WeatherViewCell.identifier)
//        tableView.edit = UIEditingInteractionConfiguration
        
        
    }
    
    
    private func setupNavigationController(){
        let searchController = UISearchController(searchResultsController: SearchResult())
        let editItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))?.withRenderingMode(.automatic), style: .plain, target: self, action: #selector(showEditView))
         
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
    
    
    private func layout(){
        tableView.backgroundColor = .black
        editView.layer.cornerRadius = 15.HAdapted
        editView.backgroundColor = .red
        editView.clipsToBounds = true
    }
    
   
    private func constraint(){
        
        view.addSubview(tableView)
        self.navigationController?.navigationBar.addSubview(editView)
        
        editView.snp.makeConstraints {[weak self] make in
            make.top.equalToSuperview().offset(50.VAdapted)
            make.right.equalToSuperview().offset(-20.HAdapted)
            self!.widthEditViewConstraint =   make.width.equalTo(0).constraint
            self!.heighEditViewConstraint =   make.height.equalTo(0).constraint
        }
        
        tableView.snp.makeConstraints {  make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(15.HAdapted)
            make.right.equalToSuperview().offset(-15.HAdapted)
            make.bottom.equalToSuperview()
        }
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
//        guard let text = searchController.searchBar.text else{
//            return
//        }
    }
    
    
    

   
}
// MARK: -  datasource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherViewCell.identifier, for: indexPath) as! WeatherViewCell
        let item = weatherItems[indexPath.row]
        cell.config(item: item)
        cell.overrideUserInterfaceStyle = .dark
        return cell
    }
    
//    MARK: - Delegate TABLEVIEW
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.isEditing {
            return 85.VAdapted
        }else{
            return 130.VAdapted
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0{
            return false
        }else{
            return true
        }
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0{
            return false
        }else{
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let selectedItem = weatherItems[sourceIndexPath.row]
        weatherItems.remove(at: sourceIndexPath.row)
        weatherItems.insert(selectedItem, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        var actions = [UIContextualAction]()

        let delete = UIContextualAction(style: .normal, title: nil) { [weak self] (contextualAction, view, completion) in
            self!.weatherItems.remove(at: indexPath.row)
            self!.tableView.deleteRows(at: [indexPath], with: .bottom)
            self!.tableView.reloadData()

            completion(true)
        }

        let largeConfig = UIImage.SymbolConfiguration(pointSize: 15.0, weight: .heavy, scale: .large)
        delete.image = UIImage(systemName: "trash", withConfiguration: largeConfig)?.withTintColor(.white, renderingMode: .alwaysTemplate).addBackgroundCircle(.red)
        delete.backgroundColor = .black
    
        actions.append(delete)

        let config = UISwipeActionsConfiguration(actions: actions)
//        config.performsFirstActionWithFullSwipe = true

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
    


}
// MARK: - Drag and drop Delegate

extension SearchViewController: UITableViewDragDelegate{
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
    
            dragItem.localObject = weatherItems[indexPath.row]
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


// MARK: - Edit data
extension SearchViewController: EditViewDelegate{
    func editData() {
        tableView.reloadData()
        tableView.layoutSubviews()
        mainViewModel.isEditDataWeather.value = true
        changeHeightCell()
        for i in 0..<weatherItems.count{
            let cell =  tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! WeatherViewCell
            cell.makeConditionLblHighLowDegreeLblHidden(is: true)
        }
    }
    
    
    @objc private func doneEdit(){
        mainViewModel.isShowEditView.value = false
        mainViewModel.isEditDataWeather.value = false
        changeHeightCell()
        tableView.reloadData()
        for i in 0..<weatherItems.count{
            let cell =  tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! WeatherViewCell
            cell.makeConditionLblHighLowDegreeLblHidden(is: false)
        }
       
    }
    
    @objc private func showEditView(){
        mainViewModel.isShowEditView.value = !mainViewModel.isShowEditView.value
//        editView.isHidden = !editView.isHidden
//        UIView.animate(withDuration: 5) {[weak self] in
//            self!.editView.isHidden = !self!.editView.isHidden
////            self!.navigationController?.navigationBar.topItem?.rightBarButtonItems?[1].tintColor = .gray
//        }
        
    }
   
    
    
}



