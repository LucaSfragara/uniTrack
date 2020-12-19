//
//  UniversityStore.swift
//  uniTrack
//
//  Created by Luca Sfragara on 20/10/2020.
//

//import Foundation
//import CoreData
//
//class UniversityStore{
//
//    var universities: [University]?
//
//    func addUniversity(_ uni: University, completion: (Result<University, StoreError>) -> ()){
//
//        if self.universities?.firstIndex(of: uni) != nil {
//            completion(.failure(.universityAlreadyExist))
//            return
//        }
//        self.universities?.append(uni)
//        completion(.success(uni))
//    }
//
//    func removeUniversity(_ uni: University, completion: (Result<University?, StoreError>)->()){
//
//        guard let indexToRemove = universities?.firstIndex(of: uni) else{
//            completion(.failure(.universityDoesNotExistInStore))
//            return
//        }
//        self.universities?.remove(at: indexToRemove)
//        PersistantService.context.delete(uni)
//        completion(.success(uni))
//    }
//
//    func fetchUniversities(completion: @escaping (Result<[University],StoreError>)->()){
//
//        let fetchRequest = NSFetchRequest<University>(entityName: "University")
//
//        var fetchedUniversities: [University] = []
//
//        guard let result = try? PersistantService.context.fetch(fetchRequest) else{
//            completion(.failure(.couldNotFetchUniversity))
//            return
//        }
//
//        for university in result{
//            fetchedUniversities.append(university)
//        }
//
//        completion(.success(fetchedUniversities))
//
//    }
//
//    func saveToPersistantStore(){
//        PersistantService.saveContext()
//    }
//
//}


