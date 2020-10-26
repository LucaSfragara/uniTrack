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

class UniversityFromJSON: Decodable{
    
     var geoPoint: String?
     var name: String?
     var address: String?
     var city: String?
     var state: String
     var zip: String?
     var telephone: String?
     var  population: String?


    enum CodingKeys: String, CodingKey{
        case geoPoint = "Geo Point"
        case name = "NAME"
        case address = "ADDRESS"
        case city = "CITY"
        case state = "STATE"
        case zip = "ZIP"
        case telephone = "TELEPHONE"
        case population = "POPULATION"
    }
    
}
