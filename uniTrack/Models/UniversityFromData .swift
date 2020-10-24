//
//  UniversityFrom .swift
//  uniTrack
//
//  Created by Luca Sfragara on 23/10/2020.
//

import Foundation
import CoreData

struct UniversityListFromJSON: Decodable{
    var universities: [UniversityFromJSON]
    
    enum CodingKeys: String, CodingKey{
        case universities = "us-colleges-and-universities"
    }
}


@objc (UniversityFromData)
class UniversityFromJSON: NSManagedObject, Decodable{
    
    @NSManaged var geoPoint: String?
    @NSManaged var name: String?
    @NSManaged var address: String?
    @NSManaged var city: String?
    @NSManaged var state: String
    @NSManaged var zip: String?
    @NSManaged var telephone: String?
    @NSManaged var population: String?
    
    required convenience init(from decoder: Decoder) throws {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "UniversityFromData", in: PersistantService.context) else{
            fatalError("No Entity found for this name")
        }
        
        self.init(entity: entity, insertInto: PersistantService.context)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try values.decode(String.self, forKey: .name)
        self.address = try values.decode(String.self, forKey: .address)
        self.city = try values.decode(String.self, forKey: .city)
        self.state = try values.decode(String.self, forKey: .state)
        self.zip = try values.decode(String.self, forKey: .zip)
        self.telephone = try values.decode(String.self, forKey: .telephone)
        self.population = try values.decode(String.self, forKey: .population)
        
    }
    
    enum CodingKeys: String, CodingKey{
        case name = "NAME"
        case address = "ADDRESS"
        case city = "CITY"
        case state = "STATE"
        case zip = "ZIP"
        case telephone = "TELEPHONE"
        case population = "POPULATION"
    }
    
}
