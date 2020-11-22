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
    @NSManaged var baseModel: UniversityFromData?
    @NSManaged var deadlines: [Date]?
    
    convenience init(name:String, course: String, reachType: ReachType?, baseModel: UniversityFromData?, deadlines: [Date]?){
        
        guard  let entity = NSEntityDescription.entity(forEntityName: "University", in: PersistantService.context) else {
            fatalError("No entity found for this name")
        }
    
        self.init(entity: entity, insertInto: PersistantService.context)
        self.name = name
        self.course = course
        self.reachType = reachType?.rawValue
        self.baseModel = baseModel
    }
    
    func addDeadline(date: Date){
        deadlines?.append(date)
    }
    
    enum ReachType: String{
        case safety = "Safety"
        case match = "Match"
        case reach = "Reach"
    }
}
