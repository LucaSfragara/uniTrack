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
    
    func addItem<Item: AddableObject>(item: Item, forUniversity university: University, completion: @escaping (Result<Bool, PersistantStoreError>) -> ()) {
        
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

    func getItems<Item>(itemClass: Item.Type, forUniversity university: University) -> [Item]? where Item : AddableObject {
        switch itemClass{
        case is Deadline.Type:
            
            let deadlines: [Deadline]? = university.sortedDeadlines(ascending: true)
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

    func updateItem<Item: AddableObject>(itemToUpdate: Item, forUniverity university: University, updateValues: [String : Any], completion: @escaping ((Result<Item, PersistantStoreError>) -> ())){
        
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
            
            let taskToUpdate = itemToUpdate as! Task
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
                    taskToUpdate.title = newText
                    
                default:
                    completion(.failure(.updateKeyNotRecognized))
                }
                
            }
        
            self.universities?[universityIndex].addTask(taskToUpdate)
            completion(.success(itemToUpdate))
        default:
            completion(.failure(.unrecognizedItem))
        }
        
        saveToPersistantStore()
        
    }

    func updateUniversity(universityToUpdate: University, updateValues: [String : Any], completion: @escaping ((Result<University, PersistantStoreError>) -> ())) {

    }

    func deleteItem<Item>(itemToDelete: Item, forUniversity university: University, completion: @escaping (Result<Bool, PersistantStoreError>) -> ()) where Item : AddableObject {
        
        let university = self.universities?[(self.universities?.firstIndex(of: university))!]
        switch itemToDelete{
        case is Deadline:
            university?.removeDeadline(itemToDelete as! Deadline)
            completion(.success(true))
        case is Task:
            university?.removeTask(itemToDelete as! Task)
            completion(.success(true))
        default:
            completion(.failure(.unrecognizedItem))
        }
        
        saveToPersistantStore()
    }

    func deleteUniversity(universityToDelete: University, completion: @escaping (Result<Bool, PersistantStoreError>) -> ()) {
        
    }
    

}

//MARK: Loading and Saving from CoreData
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
    
    func saveToPersistantStore(){
        PersistantService.saveContext()
    }
}
