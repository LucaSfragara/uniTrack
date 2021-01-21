//
//  DashboardViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 19/10/2020.
//

import UIKit
import CoreData

class DashboardViewController: UIViewController{
    
    
    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 20.0,
                                             bottom: 50.0,
                                             right: 20.0)
    
    
    @IBOutlet private weak var UpComingCollectionView: UICollectionView!
    @IBOutlet private weak var DeadlinesCollectionView: UICollectionView!
    @IBOutlet private weak var CollegesCollectionView: UICollectionView!
    
    private var universities: [University]? = []
    
    private var allDeadlines: [Deadline]? {
        get{
            return DataManager.shared.getAllItems(itemClass: Deadline.self)
        }
    }
    
    private var allTasks: [Task]?{
        get{
            return DataManager.shared.getAllItems(itemClass: Task.self)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        UpComingCollectionView.delegate = self
        UpComingCollectionView.dataSource = self
        
        DeadlinesCollectionView.delegate = self
        DeadlinesCollectionView.dataSource = self
        
        CollegesCollectionView.delegate = self
        CollegesCollectionView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        DataManager.shared.getUniversities{result in
            
            switch result {
            case .failure(let error):
                //TODO: handle error appropriately
                print(error)
            case .success(let universities):
                self.universities = universities
                self.UpComingCollectionView.reloadData()
                self.DeadlinesCollectionView.reloadData()
                self.CollegesCollectionView.reloadData()
            }
            
        }
    }
    
}


//MARK: UICollectionview delegate and datasource

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.UpComingCollectionView{
            return allTasks?.count ?? 0
            
        }else if collectionView == self.DeadlinesCollectionView{
            
            return allDeadlines?.count ?? 0
            
        }else{ //CollegeCollectionView
            return universities?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.UpComingCollectionView{ //Tasks CollectionView
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingcellID", for: indexPath) as! UpComingCollectionViewCell
            let task = allTasks?[indexPath.row]
            if let task = task{
                cell.setup(task: task)
            }
            return cell
            
        }else if collectionView == self.DeadlinesCollectionView{ //Deadlines CollectionView
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "deadlinesCellID", for: indexPath) as! DeadlinesCollectionViewCell
            
            let deadline = allDeadlines?[indexPath.row]
            if let deadline = deadline{
                cell.setup(deadline: deadline)
            }
            
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
        
        if collectionView == DeadlinesCollectionView{ //deadlines collection view

            guard let selectedDeadline = allDeadlines?[indexPath.row] else{return}
            
            let deadlineDetailVC = DeadlineDetailViewController()
            deadlineDetailVC.deadline = selectedDeadline
            self.navigationController?.pushViewController(deadlineDetailVC, animated: true)
            
        }else if collectionView == UpComingCollectionView{ //Tasks collectionView
            
            guard let selectedTask = allTasks?[indexPath.row] else {return}
            
            let taskDetailVC = TaskDetailViewController()
            taskDetailVC.task = selectedTask
            navigationController?.pushViewController(taskDetailVC, animated: true)
        }
        
        if collectionView == CollegesCollectionView{ //college collection view
            
            guard let universitySelected = universities?[indexPath.row] else{
                return
            }
            let storyboard = UIStoryboard(name: "CollegeDetail", bundle: nil)
            let detailVC = storyboard.instantiateViewController(withIdentifier: "CollegeDetailVCID") as! CollegeDetailViewController
            detailVC.university = universitySelected
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

