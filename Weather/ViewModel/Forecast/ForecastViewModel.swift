//
//  ForecastViewModel.swift
//  Weather
//
//  Created by Long Tran on 15/12/2023.
//

import UIKit
import Combine


class ForecastViewModel: ContentCardViewModel{
 
    let index = PassthroughSubject<String, Never>()
    let description = PassthroughSubject<String, Never>()
    let subDescription = PassthroughSubject<String, Never>()
    let subDescriptionViewModel = PassthroughSubject<SubViewForecastViewModel, Never>()
    
    private let _index: String?
    private let _description: String?
    private let _subDescription: String?
    private let _subDescriptionViewModel: SubViewForecastViewModel?
    
    init(index: String? = nil, description: String? = nil, subDescription: String? = nil, subDescriptionViewModel: SubViewForecastViewModel? = nil) {
        _index = index
        _description = description
        _subDescription = subDescription
        _subDescriptionViewModel = subDescriptionViewModel
    }
    
    func getData(){
        if let _index = _index{
            self.index.send(_index)
        }
        
        if let _description = _description{
            self.description.send(_description)
        }
        
        if let _subDescription = _subDescription{
            self.subDescription.send(_subDescription)
        }
        
        if let _subDescriptionViewModel = _subDescriptionViewModel{
            self.subDescriptionViewModel.send(_subDescriptionViewModel)
        }
    }
    
   
    
}
