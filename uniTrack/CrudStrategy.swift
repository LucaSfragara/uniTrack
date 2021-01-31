//
//  File.swift
//  uniTrack
//
//  Created by Luca Sfragara on 19/12/20.
//

import Foundation

protocol CrudStrategy: class{
    
    var universities: [University]? {get}
    
    //MARK: CREATE
    ///add - add task or deadline to university
    func addItem<Item: AddableObject>(item: Item, completion: @escaping(Result<Bool, PersistantStoreError>)->())
    func createUniversity(university: University, completion: @escaping (Result<Bool, PersistantStoreError>) -> ())
    
    
    //MARK: READ
    ///read - get all items
    func getItems<Item: AddableObject>(itemClass: Item.Type, forUniversity university: University) -> [Item]?
    func getUniversities(withNameContaining text: String?, completion: @escaping(Result<[University], PersistantStoreError>)->())

    //MARK: UPDATE
    func updateItem<Item: AddableObject>(itemToUpdate: Item, updateValues: [String : Any], completion: @escaping((Result<AddableObject, PersistantStoreError>) -> ()))
    func updateUniversity(universityToUpdate: University, updateValues: [String : Any?], completion: @escaping((Result<University, PersistantStoreError>) -> ()))
    
    //MARK: DELETE
    func deleteItem<Item: AddableObject>(itemToDelete: Item, completion: @escaping(Result<Bool, PersistantStoreError>) -> ())
    func deleteUniversity(universityToDelete: University,  completion: @escaping(Result<University, PersistantStoreError>) -> ())
    
    func deleteAllUniversities(completion: @escaping(Result<Bool, PersistantStoreError>) -> ())
}

protocol AddableObject: class{
    var university: University {get}
}

//MARK: custom error
enum PersistantStoreError:Error{
    
    case couldNotDeleteItem
    case couldNotDeleteUniversity
    case couldNotUpdateUniversity
    case couldNotUpdateItem
    case couldNotAddItemToUniversity
    case universityAlreadyExist
    case universityDoesNotExistInStore
    case couldNotFetchUniversities
    case unrecognizedItem
    
    //update
    case updateKeyNotRecognized
    case updateValueNotValid
    case linkIsNotValid //To be thrown if pinging the url does not return code 200
}

extension PersistantStoreError: LocalizedError{
    
    public var errorDescription: String?{
        switch self{
        case .universityAlreadyExist:
            return "The university you tried to add is already in the list"
        case .universityDoesNotExistInStore:
            return "The university you tried to delete does not exist in the store"
        case .couldNotFetchUniversities:
            return "An error occured while fetching universities from coreData"
        default:
            return "No errorDescription provided for this error"
        }
        
        
    }
   
}
