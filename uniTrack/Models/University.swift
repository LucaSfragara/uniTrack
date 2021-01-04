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
    @NSManaged var reachType: ReachType.RawValue?
    @NSManaged var photo: String
    @NSManaged var dateOfAdd: Date
    
    @NSManaged var baseModel: UniversityFromData?
    @NSManaged var deadlines: NSSet?
    @NSManaged var todos: NSSet?
    
    func getDeadlines() -> [Deadline]?{
        
        guard let deadlinesArray = deadlines?.allObjects as? [Deadline] else{
            return nil
        }
        return deadlinesArray
    }
    
    func getTodos()->[Task]?{
        
        return (todos?.allObjects as? [Task])
        
    }
    
    convenience init(name:String, course: String, reachType: ReachType?, baseModel: UniversityFromData?, deadlines: [Date]?){
        
        guard  let entity = NSEntityDescription.entity(forEntityName: "University", in: PersistantService.context) else {
            fatalError("No entity found for this name")
        }
    
        self.init(entity: entity, insertInto: PersistantService.context)
        self.name = name
        self.course = course
        self.reachType = reachType?.rawValue
        self.baseModel = baseModel
        self.dateOfAdd = Date()
        
    }
    
    @objc(addDeadlinesObject:)
    @NSManaged func addDeadline(_ value: Deadline)

    @objc(removeDeadlinesObject:)
    @NSManaged func removeDeadline(_ value: Deadline)

    @objc(addTodosObject:)
    @NSManaged func addTask(_ value: Task)

    @objc(removeTodosObject:)
    @NSManaged func removeTask(_ value: Task)

    
    enum ReachType: String{
        case safety = "Safety"
        case match = "Match"
        case target = "Target"
    }
}

