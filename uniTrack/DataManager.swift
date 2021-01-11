//
//  DataManage.swift
//  uniTrack
//
//  Created by Luca Sfragara on 19/12/20.
//

import Foundation
import CoreData

//DATA MANAGER SINGLETON
class DataManager: CrudStrategy{
    

    var universities: [University]?
    
    static var shared = DataManager()
    
    init(){}
}

//MARK: CREATE
extension DataManager{
    func addItem<Item: AddableObject>(item: Item, completion: @escaping (Result<Bool, PersistantStoreError>) -> ()) {
        
        let university = item.university
        switch item{
        case is Deadline:
            university.addDeadline(item as! Deadline)
            completion(.success(true))
        case is Task:
            university.addTask(item as! Task)
            completion(.success(true))
        default:
            completion(.failure(.unrecognizedItem))
            return
        }
        
    }

    func createUniversity(university: University, completion: @escaping (Result<Bool, PersistantStoreError>) -> ()) {
        self.universities?.append(university)
        completion(.success(true))
    }
}

//MARK: READ
extension DataManager{
    
    func getAllItems<Item: AddableObject>(itemClass: Item.Type, sortAscending: Bool = true) -> [Item]?{
        
        guard let universities = universities else{return nil}
        
        switch itemClass {
        
        case is Deadline.Type:
            
            let deadlines: [Deadline] = universities.flatMap{($0.getDeadlines() ?? [])}
            let sortedDeadlines = sortDeadlines(deadlines: deadlines, ascending: sortAscending)
            
            return sortedDeadlines as [Deadline] as? [Item]
            
        case is Task.Type:
            let tasks: [Task] = universities.flatMap{($0.getTodos() ?? [])}
            return tasks as [Task] as? [Item]
        default:
            return nil
        }
        
    }
    
    func getItems<Item>(itemClass: Item.Type, forUniversity university: University) -> [Item]? where Item : AddableObject {
        switch itemClass{
        case is Deadline.Type:
            
            let deadlines: [Deadline]? = university.getDeadlines()
            return deadlines as [Deadline]? as? [Item]
            
        case is Task.Type:
            return university.getTodos() as [Task]? as? [Item]
            
        default:
            return nil
        }

        
    }

    func getUniversities(withNameContaining text: String? = nil, completion: @escaping(Result<[University], PersistantStoreError>)->()){
        
        loadFromCoreData(withNameContaining: text){result in
            
            switch result{
            case .failure(let error):
                completion(.failure(error))
            case .success(let fetchedUniversities):
                self.universities = fetchedUniversities
                completion(.success(self.universities!))
            }
        }
    }
    
    func getSortedUniversities(byDateAscending ascending: Bool, completion: @escaping(Result<[University], PersistantStoreError>)->()){
        
        loadFromCoreData(withSortByDateAscending: ascending){result in
            
            switch result{
            case .failure(let error):
                completion(.failure(error))
            case .success(let fetchedUniversities):
                completion(.success(fetchedUniversities))
            }
            
        }
    }
}
//MARK: UPDATE
extension DataManager{
    func updateItem<Item: AddableObject>(itemToUpdate: Item, updateValues: [String : Any], completion: @escaping ((Result<AddableObject, PersistantStoreError>) -> ())){
        
        let university = itemToUpdate.university
        let universityIndex = (self.universities?.firstIndex(of: university))!
        
        switch itemToUpdate{
        case is Deadline:
            
            let deadlineToUpdate = itemToUpdate as! Deadline
            self.universities?[universityIndex].removeDeadline(deadlineToUpdate)
            
            for (key, value) in updateValues{
                
                switch key.lowercased(){
                case "date":
                    guard let newDate = value as? Date else{
                        completion(.failure(.updateValueNotValid))
                        return
                    }
                    deadlineToUpdate.date = newDate
                    
                case "title":
                    guard let newTitle = value as? String else{
                        completion(.failure(.updateValueNotValid))
                        return
                    }
                    deadlineToUpdate.title = newTitle
                    
                default:
                    completion(.failure(.updateKeyNotRecognized))
                }
                
            }
        
            self.universities?[universityIndex].addDeadline(deadlineToUpdate)
            completion(.success(itemToUpdate))
            
        case is Task:
            
            let taskToUpdate = itemToUpdate as Item as! Task
            self.universities?[universityIndex].removeTask(taskToUpdate)
            for (key, value) in updateValues{
            
                switch key.lowercased(){
                case "title":
                    guard let newTitle = value as? String else{
                        completion(.failure(.updateValueNotValid))
                        return
                    }
                    taskToUpdate.title = newTitle
                    
                case "text":
                    guard let newText = value as? String else{
                        completion(.failure(.updateValueNotValid))
                        return
                    }
                    taskToUpdate.text = newText
                    
                default:
                    completion(.failure(.updateKeyNotRecognized))
                }
                
            }
        
            self.universities?[universityIndex].addTask(taskToUpdate)
            completion(.success(taskToUpdate))
        default:
            completion(.failure(.unrecognizedItem))
        }
        
        saveToPersistantStore()
        
    }

    func updateUniversity(universityToUpdate: University, updateValues: [String : Any?], completion: @escaping ((Result<University, PersistantStoreError>) -> ())){
        
        for (key, value) in updateValues{
            
            guard value != nil else{continue} //Do not change attribute if value is nil
            
            switch key{
            case "name":
                
                guard let newName = value as? String else{
                    completion(.failure(.updateValueNotValid))
                    return
                }
                universityToUpdate.baseModel?.name = newName
                universityToUpdate.name = newName
                
            case "course":
                
                guard let newCourse = value as? String else{
                    completion(.failure(.updateValueNotValid))
                    return
                }
                universityToUpdate.course = newCourse
            
            case "reachtype":
                
                guard let newReachType = value as? University.ReachType else{
                    completion(.failure(.updateValueNotValid))
                    return
                }
                universityToUpdate.reachType = newReachType.rawValue
                
            
            case "link":
                
                guard let newLink = value as? String else{
                    completion(.failure(.updateValueNotValid))
                    return
                }
                
                if newLink.isEmpty{
                    universityToUpdate.URL = nil
                    break
                }
                guard let newURL = URL(string: newLink) else{
                    completion(.failure(.updateValueNotValid))
                    return
                }
                
                universityToUpdate.URL = newURL
                
            //EDITS on base model
            
            case "population":
                
                guard let newPopulation = value as? Int else{
                    completion(.failure(.updateValueNotValid))
                    return
                }
                universityToUpdate.baseModel?.population = String(newPopulation)
            
            
           case "isoCountryCode":

                guard let newIsoCode = value as? String else{
                    completion(.failure(.updateValueNotValid))
                    return
                }
            universityToUpdate.isoCountryCode = newIsoCode
                    
            case "state":
                
                guard let newState = value as? String else{
                    completion(.failure(.updateValueNotValid))
                    return
                }
                universityToUpdate.baseModel?.state = newState
         
                
            default:
                print(key)
                completion(.failure(.updateKeyNotRecognized))
                return
            }
            
        }
        completion(.success(universityToUpdate))
        saveToPersistantStore()
    }
}

//MARK: DELETE
extension DataManager{
    func deleteItem<Item>(itemToDelete: Item, completion: @escaping (Result<Bool, PersistantStoreError>) -> ()) where Item : AddableObject {
        
        
        let university = self.universities?[(self.universities?.firstIndex(of: itemToDelete.university))!]
        switch itemToDelete{
        case is Deadline:
            university?.removeDeadline(itemToDelete as! Deadline)
            PersistantService.context.delete(itemToDelete as! Deadline)
            completion(.success(true))
        case is Task:
            university?.removeTask(itemToDelete as! Task)
            PersistantService.context.delete(itemToDelete as! Task)
            completion(.success(true))
        default:
            completion(.failure(.unrecognizedItem))
        }
        
        saveToPersistantStore()
    }

    func deleteUniversity(universityToDelete: University, completion: @escaping (Result<University, PersistantStoreError>) -> ()) {
        
        PersistantService.context.delete(universityToDelete)
        completion(.success(universityToDelete))
        saveToPersistantStore()
    }
    

}



//MARK: HELPERS - Loading and Saving from CoreData
extension DataManager{
    
    private func loadFromCoreData(withNameContaining inputText: String? = nil, completion: @escaping(Result<[University], PersistantStoreError>)->()){
        
        let fetchRequest = NSFetchRequest<University>(entityName: "University")
        
        if let text = inputText {
            let fetchPredicate = NSPredicate(format: "name CONTAINS[c] %@", text)
            fetchRequest.predicate = fetchPredicate
        }
        
        do {
            let result = try PersistantService.context.fetch(fetchRequest)
            completion(.success(result))
        } catch{
            //TODO: switch error type here and throw appropriate persistansStoreError
            completion(.failure(.couldNotFetchUniversities))
        }
    }
    
    private func loadFromCoreData(withSortByDateAscending ascending: Bool, completion: @escaping(Result<[University], PersistantStoreError>)->()){
        
        let fetchRequest = NSFetchRequest<University>(entityName: "University")
        let sortDescripor = NSSortDescriptor(key: "dateOfAdd", ascending: ascending)
        fetchRequest.sortDescriptors = [sortDescripor]
        
        do {
            let result = try PersistantService.context.fetch(fetchRequest)
            completion(.success(result))
        } catch{
            //TODO: switch error type here and throw appropriate persistansStoreError
            completion(.failure(.couldNotFetchUniversities))
        }
    }
    
    
    func saveToPersistantStore(){
        PersistantService.saveContext()
    }
    
    //sortDeadline by date
    private func sortDeadlines(deadlines: [Deadline], ascending: Bool) -> [Deadline]{
        
        let sortedDeadlines = deadlines.sorted{
            if ascending{ //sort in ascending order
                return $0.date < $1.date
            }else{ //sort in descending order
                return $0.date > $1.date
            }
        }
        
        return sortedDeadlines
    }
}

