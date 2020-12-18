//
//  Deadline.swift
//  uniTrack
//
//  Created by Luca Sfragara on 13/12/20.
//

import Foundation
import CoreData

@objc(Deadline)
class Deadline: NSManagedObject{
    
    @NSManaged var date: Date
    @NSManaged var title: String
    
    convenience init(date: Date, title: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Deadline", in: PersistantService.context) else{
            fatalError("No entity found for this name")
        }
        self.init(entity: entity, insertInto: PersistantService.context)
        
        self.date = date
        self.title = title
        
    }
    
}
