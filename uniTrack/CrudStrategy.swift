//
//  File.swift
//  uniTrack
//
//  Created by Luca Sfragara on 19/12/20.
//

import Foundation

protocol CrudStrategy{
    
    //MARK: CREATE
    ///add - add task or deadline to university
    func addItem<Item: AddableObject>(item: Item, forUniversity: University, completion: (Result<Bool, PersistantStoreError>)->())
    func createUniversity(university: University, completion: @escaping (Result<Bool, PersistantStoreError>) -> ())
    
    
    //MARK: READ
    ///read - get all items
    func getItems<Item: AddableObject>(forUniversity: University) -> [Item]?
    func getUniversities(withNameContaining: String) -> [University]

    //MARK: UPDATE
    func updateItem<Item: AddableObject>(itemToUpdate: Item, forUniverity: University, updateValues: [String : String], completion: @escaping((Result<Item, PersistantStoreError>) -> ()))
    func updateUniversity(universityToUpdate: University, updateValues: [String : String], completion: @escaping((Result<University, PersistantStoreError>) -> ()))
    
    //MARK: DELETE
    func deleteItem<Item: AddableObject>(itemToDelete: Item, forUniversity:University, completion: @escaping(Result<Bool, PersistantStoreError>) -> ())
    func deleteUniversity(universityToDelete: University,  completion: @escaping(Result<Bool, PersistantStoreError>) -> ())
}

protocol AddableObject: class{
    
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
    case couldNotFetchUniversity
}

extension PersistantStoreError: LocalizedError{
    
    public var errorDescription: String?{
        switch self{
        case .universityAlreadyExist:
            return "The university you tried to add is already in the list"
        case .universityDoesNotExistInStore:
            return "The university you tried to delete does not exist in the store"
        case .couldNotFetchUniversity:
            return "An error occured while fetching universities from coreData"
        default:
            return "No errorDescription provided for this error"
        }
        
        
    }
   
}
