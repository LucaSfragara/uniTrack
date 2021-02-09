//
//  University.swift
//  uniTrack
//
//  Created by Luca Sfragara on 19/10/2020.
//

import Foundation
import CoreData
import UIKit

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
    @NSManaged var isoCountryCode: String
    @NSManaged var link: String?
    @NSManaged var notes: String?
    @NSManaged var uuidName: String
    
    @NSManaged var baseModel: UniversityFromData?
    @NSManaged var deadlines: NSSet?
    @NSManaged var todos: NSSet?
    
    var URL: URL?{
        get{
            guard let link = link else {return nil}
            return Foundation.URL(string: link)
        }
        set{
            self.link = newValue?.absoluteString
        }
    }
    
    var country: Country?{
        get{
            return Utilities.countryList().first(where: {$0.isoCountryCode == self.isoCountryCode})
        }
        set{
            guard let newISOCountryCode = newValue?.isoCountryCode else{return}
            self.isoCountryCode = newISOCountryCode
        }
    }
    
    func getDeadlines() -> [Deadline]?{
        
        guard let deadlinesArray = deadlines?.allObjects as? [Deadline] else{
            return nil
        }
        return deadlinesArray
    }
    
    func getTasks(sortByCompletedFirst: Bool = true)->[Task]?{ //if nil doesn't sort, otherwise it sorts
         
        let tasks: [Task]?
        
        if sortByCompletedFirst{
            tasks = (todos?.allObjects as? [Task])?.sorted(by: {!$0.isCompleted && $1.isCompleted})
        }else{
            tasks = todos?.allObjects as? [Task]
        }

        return tasks
        
    }
    
    convenience init(name:String, course: String, countryIsoCode: String, reachType: ReachType?, baseModel: UniversityFromData?){
        
        guard  let entity = NSEntityDescription.entity(forEntityName: "University", in: PersistantService.context) else {
            fatalError("No entity found for this name")
        }
    
        self.init(entity: entity, insertInto: PersistantService.context)
        self.name = name
        self.course = course.capitalizingFirstLetter()
        self.reachType = reachType?.rawValue
        self.baseModel = baseModel
        self.dateOfAdd = Date()
        self.isoCountryCode = countryIsoCode
        self.uuidName = name
        
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

