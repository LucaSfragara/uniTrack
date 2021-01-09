//
//  Task.swift
//  uniTrack
//
//  Created by Luca Sfragara on 13/12/20.
//

import Foundation
import CoreData

@objc(Task)
class Task: NSManagedObject, AddableObject{
    
    @NSManaged var title: String
    @NSManaged var text: String
    @NSManaged var university: University
    @NSManaged var isCompleted: Bool
    
    convenience init(taskTitle title: String, taskText text: String, forUniversity university: University, isCompleted: Bool = false){
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: PersistantService.context) else{
            fatalError("No entity found for this name")
        }
        
        self.init(entity: entity, insertInto: PersistantService.context)
        self.title = title
        self.text = text
        self.isCompleted = isCompleted
        self.university = university
    }
    
}

