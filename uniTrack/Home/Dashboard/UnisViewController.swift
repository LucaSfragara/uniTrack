//
//  UnisViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 19/10/2020.
//

import UIKit
import CoreData

class UnisViewController: SwipableViewController {
    
    
    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 20.0,
                                             bottom: 50.0,
                                             right: 20.0)
    
    
    @IBOutlet private weak var UpComingCollectionView: UICollectionView!
    @IBOutlet private weak var DeadlinesCollectionView: UICollectionView!
    @IBOutlet private weak var CollegesCollectionView: UICollectionView!
    
    private var universities: [University]? = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
    
        UpComingCollectionView.delegate = self
        UpComingCollectionView.dataSource = self
        
        DeadlinesCollectionView.delegate = self
        DeadlinesCollectionView.dataSource = self
        
        CollegesCollectionView.delegate = self
        CollegesCollectionView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchMyUniversity()
    }
    
    private func fetchMyUniversity(){
        
        let fetchRequest = NSFetchRequest<University>(entityName: "University")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
    
        let result = try? PersistantService.context.fetch(fetchRequest) 
        
        guard let fetchedUniversities = result else{
            return
        }
        universities = fetchedUniversities
        DispatchQueue.main.async {
            self.UpComingCollectionView.reloadData()
            self.DeadlinesCollectionView.reloadData()
            self.CollegesCollectionView.reloadData()
        }
    }
}

//MARK: UITabbar controleller delegate
extension UnisViewController: UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let CollegeVC = viewController.children[0] as? MyCollegesViewController{
            //CollegeVC.universities = self.universities
            CollegeVC.universities = self.universities
        }
    }
}

//MARK: UICollectionview delegate and datasource

extension UnisViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.UpComingCollectionView{
            return universities?.count ?? 0
        }else if collectionView == self.DeadlinesCollectionView{
            
            let filteredUniversity = universities?.filter{ university in
                return (university.deadlines?.count ?? 0) > 0 //display on deadlines collection only colleges with deadlines
            }
            return filteredUniversity?.count ?? 0
            
        }else{ //CollegeCollectionView
            return universities?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.UpComingCollectionView{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingcellID", for: indexPath) as! UpComingCollectionViewCell
            cell.setup(universityName: "Harvard", task: "Aid applications")
            return cell
            
        }else if collectionView == self.DeadlinesCollectionView{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "deadlinesCellID", for: indexPath) as! DeadlinesCollectionViewCell
            
            let filteredUniversity = universities?.filter{ university in
                return (university.deadlines?.count ?? 0) > 0 //display on deadlines collection only colleges with deadlines
            }
            cell.setup(university: filteredUniversity?[indexPath.row])
            
            return cell
            
        }else{ // CollegesCollectionView
           
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dashboardCollegeCellID", for: indexPath) as! DashboardCollegesCollectionViewCell
            cell.setup(university: self.universities?[indexPath.row])
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == CollegesCollectionView{ //college collection view
            
            guard let universitySelected = universities?[indexPath.row] else{
                return
            }
            let storyboard = UIStoryboard(name: "CollegeDetail", bundle: nil)
            let detailVC = storyboard.instantiateViewController(withIdentifier: "CollegeDetailVCID") as! CollegeDetailViewController
            detailVC.university = universitySelected
            present(detailVC, animated: true, completion: nil)
        }
        
    }
}

