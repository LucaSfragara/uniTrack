//
//  Task.swift
//  uniTrack
//
//  Created by Luca Sfragara on 13/12/20.
//

import Foundation
import CoreData

@objc(Task)
class Task: NSManagedObject{
    
    @NSManaged var title: String
    @NSManaged var text: String
    
    convenience init(taskTitle title: String, taskText text: String){
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: PersistantService.context) else{
            fatalError("No entity found for this name")
        }
        
        self.init(entity: entity, insertInto: PersistantService.context)
        self.title = title
        self.text = text
        
    }
    
}
