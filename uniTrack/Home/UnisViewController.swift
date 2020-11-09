//
//  UnisViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 19/10/2020.
//

import UIKit
import CoreData

class UnisViewController: UIViewController {
    
    
    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 20.0,
                                             bottom: 50.0,
                                             right: 20.0)

    
    @IBOutlet private weak var UpComingCollectionView: UICollectionView!
    @IBOutlet private weak var DeadlinesCollectionView: UICollectionView!
    @IBOutlet private weak var CollegesCollectionView: UICollectionView!
    
    private var unisList: [UniversityFromJSON]? = []
    private var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFetchedResultController()
        
        UpComingCollectionView.delegate = self
        UpComingCollectionView.dataSource = self
        
        DeadlinesCollectionView.delegate = self
        DeadlinesCollectionView.dataSource = self
        
        CollegesCollectionView.delegate = self
        CollegesCollectionView.dataSource = self
        
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

//MARK: UICollectionview delegate and datasource
extension UnisViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.UpComingCollectionView{
            return 10
        }else if collectionView == self.DeadlinesCollectionView{
            return 20
        }else{ //CollegeCollectionView
            return 20
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.UpComingCollectionView{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingcellID", for: indexPath) as! UpComingCollectionViewCell
            cell.setup(universityName: "Harvard", task: "Aid applications")
            return cell
            
        }else if collectionView == self.DeadlinesCollectionView{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "deadlinesCellID", for: indexPath) as! DeadlinesCollectionViewCell
            cell.setup(universityName: "Carnegie Mellon", date: Date())
            return cell
            
        }else{ // CollegesCollectionView
           
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collegeCellID", for: indexPath) as! CollegesCollectionViewCell
            //cell.setup(photoImage: nil, name: "Yale College", course: "Business and Law", schoolType: .safety)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.UpComingCollectionView{
            return CGSize(width: view.frame.width/2, height: collectionView.frame.height)
        }else if collectionView == self.DeadlinesCollectionView{
            return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.height)
        }else{ //CollegeCollectionView
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/2.3)
        }
        
    }
}



//MARK: fetchRequestController Delegate

extension UnisViewController: NSFetchedResultsControllerDelegate{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
}
