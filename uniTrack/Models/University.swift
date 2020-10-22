//
//  University.swift
//  uniTrack
//
//  Created by Luca Sfragara on 19/10/2020.
//

import Foundation
import CoreData

@objc(University)

public class University: NSManagedObject{
    
    static public func == (lhs: University, rhs: University) -> Bool {
        return lhs.name == rhs.name ? true : false
    }
    
    @NSManaged var name: String
    @NSManaged var course: String
    
    convenience init(name:String, course: String){
        
        guard  let entity = NSEntityDescription.entity(forEntityName: "University", in: PersistantService.context) else {
            fatalError("No entity found for this name")
        }
    
        self.init(entity: entity, insertInto: PersistantService.context)
        self.name = name
        self.course = course
        
        
    }
    
}
