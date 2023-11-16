//
//  Location+CoreDataProperties.swift
//  
//
//  Created by Long Tran on 12/11/2023.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var name: String?

}
