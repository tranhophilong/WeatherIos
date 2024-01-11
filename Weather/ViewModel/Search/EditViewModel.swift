//
//  EditViewModel.swift
//  Weather
//
//  Created by Long Tran on 28/12/2023.
//

import Foundation
import Combine


protocol EventEditDelegate: AnyObject{
    func editListWeatherCell()
    func changeToCel()
    func changeToFah()
}

class EditViewModel{
    weak var delegate: EventEditDelegate?
    let editCellViewModels = PassthroughSubject<[EditCellViewModelProtocol], Never>()
    
//    init(){
//        editCellViewModels.send([EditCellEditListWeatherCellViewModel(), EditCellCelsiusViewModel(), EditCellFahrenheitViewModel()])
//    }
    
    func getEditCellViewModels(){
        editCellViewModels.send([EditCellEditListWeatherCellViewModel(), EditCellCelsiusViewModel(), EditCellFahrenheitViewModel()])
    }
    
}
