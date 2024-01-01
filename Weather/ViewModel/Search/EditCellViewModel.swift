//
//  EditCellViewModel.swift
//  Weather
//
//  Created by Long Tran on 28/12/2023.
//

import Foundation



protocol EditCellViewModelProtocol{
    var title: String { get set}
    var nameIcon: String? { get set}
    var symbolText: String? {get set}
}

struct EditCellCelsiusViewModel: EditCellViewModelProtocol{
    
    var symbolText: String? = "°C"
    var title: String = "Celsius"
    var nameIcon: String? = nil
    
}

struct EditCellFahrenheitViewModel: EditCellViewModelProtocol{
    
    var symbolText: String? = "°F"
    var title: String = "Fahrenheit"
    var nameIcon: String? = nil
    
}

struct EditCellEditListWeatherCellViewModel: EditCellViewModelProtocol{
    
    var symbolText: String? = nil
    var title: String = "Edit List"
    var nameIcon: String? = "pencil"
    
    
}
