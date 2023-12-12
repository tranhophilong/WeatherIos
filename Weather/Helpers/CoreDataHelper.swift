//
//  CoreDataHelper.swift
//  Weather
//
//  Created by Long Tran on 01/12/2023.
//

import CoreData
import UIKit

class CoreDataHelper{
    
    static let shared = CoreDataHelper()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getNameIdOrderLocation() -> [Int16 : String]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        request.returnsDistinctResults  = true
        request.sortDescriptors = [NSSortDescriptor(key: "idOrder", ascending: true)]
        var locations: [Int16: String] = [:]
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                let id = data.value(forKey: "idOrder") as! Int16
                let nameLocation = data.value(forKey: "name") as! String
                locations[id] = nameLocation
            }
        }catch{
            print("fail get data")
        }
        return locations
    }
    
    func getNameLocationsCoreData() -> [String]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        request.returnsDistinctResults  = true
        request.sortDescriptors = [NSSortDescriptor(key: "idOrder", ascending: true)]
        var nameLocations: [String] = []
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                nameLocations.append(data.value(forKey: "name") as! String)
            }
        }catch{
            print("fail get data")
        }
        return nameLocations
    }
    
    func reorderLocationCoreData(sourcePosition: Int16, destinationPostion: Int16){
        let fetchRequestSourcePos: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequestSourcePos.predicate = NSPredicate(format: "idOrder == %d", sourcePosition)
        
        let fetchRequestDesPos: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequestDesPos.predicate = NSPredicate(format: "idOrder == %d", destinationPostion)
        
        
        do{
            let scoureObj = try context.fetch(fetchRequestSourcePos).first!
            let tempId = scoureObj.idOrder
            let desObj = try context.fetch(fetchRequestDesPos).first!
            scoureObj.idOrder = desObj.idOrder
            desObj.idOrder = tempId
            
            try context.save()
            
        }catch{
            print("error save")
        }
       
    }
    
    func addNameLocationCoredata(locationName: String){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        request.returnsDistinctResults  = true
        
        do{
            let numObjecCoreData =  try context.fetch(request).count
            let entity = NSEntityDescription.entity(forEntityName: "Location", in: context)
            let newLocation = NSManagedObject(entity: entity!, insertInto: context)
            newLocation.setValue(locationName, forKey: "name")
            newLocation.setValue(numObjecCoreData, forKey: "idOrder")
        }catch{
            print("error get num object")
        }
        
        do{
            try context.save()
        }catch{
            print("error add object")
        }
    }
}
