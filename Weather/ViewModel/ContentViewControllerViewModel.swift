//
//  ContentViewControllerViewModel.swift
//  Weather
//
//  Created by Long Tran on 28/11/2023.
//

import Combine
import CoreData
import UIKit

class ContentViewControllerViewModel{
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func addNameLocationCoredata(locationName: String){
        
        CoreDataHelper.shared.addNameLocationCoredata(locationName: locationName)
    }
    
}
