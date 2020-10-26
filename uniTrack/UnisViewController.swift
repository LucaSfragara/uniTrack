//
//  UnisViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 19/10/2020.
//

import UIKit
import CoreData

class UnisViewController: UIViewController {

    @IBOutlet private weak var tableview: UITableView!
    
    private var unisList: [UniversityFromJSON]? = []
    private var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFetchedResultController()
        //unisList?.append(contentsOf: [University(name: "Harvard", course: "Computer Science"), University(name: "Politecnico", course: "eng")])
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    private func configureFetchedResultController(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UniversityFromData")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true) //Sort by alphebetical order A-Z
        fetchRequest.sortDescriptors = [sortDescriptor ]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: PersistantService.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController?.delegate =  self
        
        do {
            try fetchedResultController?.performFetch()
        } catch{
            print(error.localizedDescription)
        }
        
    }
}

//MARK: tableview datasource and delegate
extension UnisViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultController?.sections else{
            return 0
        }
        
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "UnisListTableViewCell", for: indexPath) as! UnisListTableViewCell
        
        if let university = fetchedResultController?.object(at: indexPath) as? UniversityFromData{
        
            cell.update(universityName: university.name, universityCourse: university.state)
            
        }
        return cell
    }
    
}

//MARK: fetchRequestController Delegate

extension UnisViewController: NSFetchedResultsControllerDelegate{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableview.reloadData()
    }
}
