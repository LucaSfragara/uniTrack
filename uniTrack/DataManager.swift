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
    
    func doesNameAlreadyExist(forName name: String, completion: @escaping (Bool)->()){ //Returns true if name already exist
        loadFromCoreData(){ result in
            switch result{
            case .failure(let error):
                print("error")
            case .success(let universities):
                for university in universities{
                    if university.uuidName == name{
                        completion(true)
                        return
                    }
                }
                completion(false)
                return
            }
        }
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
            var tasks: [Task] = universities.flatMap{($0.getTasks() ?? [])}
            tasks.sort(by: {!$0.isCompleted && $1.isCompleted})
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
            return university.getTasks() as [Task]? as? [Item]
            
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
                        completion(.failure(.updateValueNotValid(forKey: "date", withValue: value)))
                        return
                    }
                    deadlineToUpdate.date = newDate
                    
                case "title":
                    guard let newTitle = value as? String else{
                        completion(.failure(.updateValueNotValid(forKey: "title", withValue: value)))
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
                        completion(.failure(.updateValueNotValid(forKey: "title", withValue: value)))
                        return
                    }
                    taskToUpdate.title = newTitle
                    
                case "text":
                    guard let newText = value as? String else{
                        completion(.failure(.updateValueNotValid(forKey: "text", withValue: value)))
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
            
            //guard value != nil else{continue} //Do not change attribute if value is nil
            
            switch key{
            case "name":
                
                guard let newName = value as? String else{
                    completion(.failure(.updateValueNotValid(forKey: "name", withValue: value)))
                    return
                }
                universityToUpdate.name = newName
                
            case "course":
                
                guard let newCourse = value as? String else{
                    completion(.failure(.updateValueNotValid(forKey: "course", withValue: value)))
                    return
                }
                universityToUpdate.course = newCourse.capitalizingFirstLetter()
            
            case "reachtype":
                
                guard value != nil else{
                    universityToUpdate.reachType = nil
                    continue
                }
                
                guard let newReachType = value as? University.ReachType else{
                    completion(.failure(.updateValueNotValid(forKey: "reachtype", withValue: value)))
                    return
                }
                universityToUpdate.reachType = newReachType.rawValue

            
            case "link":
                
                guard value != nil else{
                    universityToUpdate.link = nil
                    continue
                }
                
                guard let newLink = value as? String else{
                    completion(.failure(.updateValueNotValid(forKey: "link", withValue: value)))
                    return
                }
                
                if newLink.isEmpty{
                    universityToUpdate.URL = nil
                    break
                }
                guard let newURL = URL(string: newLink) else{
                    completion(.failure(.updateValueNotValid(forKey: "link", withValue: value)))
                    return
                }
            
                universityToUpdate.URL = newURL
            
            case "notes":
                
                guard let newNotes = value as? String else{
                    completion(.failure(.updateValueNotValid(forKey: "notes", withValue: value)))
                    return
                }
                
                universityToUpdate.notes = newNotes
                
                
            //EDITS on base model
            
            case "population":
                guard value != nil else{
                    continue
                }
                guard let newPopulation = value as? Int else{
                    completion(.failure(.updateValueNotValid(forKey: "population", withValue: value)))
                    return
                }
                universityToUpdate.baseModel?.population = String(newPopulation)
            
            
           case "isoCountryCode":

                guard let newIsoCode = value as? String else{
                    completion(.failure(.updateValueNotValid(forKey: "isoCountryCode", withValue: value)))
                    return
                }
            universityToUpdate.isoCountryCode = newIsoCode
                    
            case "state":
                
                guard value != nil else{
                    continue
                }
                
                guard let newState = value as? String else{
                    completion(.failure(.updateValueNotValid(forKey: "state", withValue: value)))
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
    
    func deleteAllUniversities(completion: @escaping(Result<Bool, PersistantStoreError>) ->()){
        loadFromCoreData{[weak self] (result) in
            switch result{
            case .success(let universities):
                for university in universities{
                    self?.deleteUniversity(universityToDelete: university){_ in}
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
        
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            do {
                let result = try PersistantService.context.fetch(fetchRequest)
                completion(.success(result))
            } catch{
                //TODO: switch error type here and throw appropriate persistansStoreError
                completion(.failure(.couldNotFetchUniversities))
            }

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

