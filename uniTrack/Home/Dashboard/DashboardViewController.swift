//
//  DashboardViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 19/10/2020.
//

import UIKit
import CoreData
import EmptyStateKit

class DashboardViewController: UIViewController{
    
    
    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 20.0,
                                             bottom: 50.0,
                                             right: 20.0)
    
    
    @IBOutlet private weak var UpComingCollectionView: UICollectionView!
    @IBOutlet private weak var DeadlinesCollectionView: UICollectionView!
    @IBOutlet private weak var CollegesCollectionView: UICollectionView!
    
    @IBOutlet weak var CollegecollectionLayout: UICollectionViewFlowLayout! {
        didSet {
            CollegecollectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
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
        
        //setup emptyStatekit
        setupEmptyStateView()
    
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        DataManager.shared.getUniversities{result in
            
            switch result {
            case .failure(let error):
                //TODO: handle error appropriately
                print(error)
            case .success(let universities):
                self.universities = universities
                
                DispatchQueue.main.async {
                    self.UpComingCollectionView.reloadData()
                    self.DeadlinesCollectionView.reloadData()
                    self.CollegesCollectionView.reloadData()
                }
                
            }
            
        }
    }
    
    private func setupEmptyStateView(){
        
        var format = EmptyStateFormat()
        format.titleAttributes = [.font: UIFont(name: "Inter-bold", size: 20)!, .foregroundColor: UIColor.black]
        format.descriptionAttributes = [.font: UIFont(name: "Inter-medium", size: 14)!, .foregroundColor: UIColor(named: "uniTrack secondary label color")]
        format.backgroundColor = UIColor(named: "uniTrack Light Grey")!
        format.buttonWidth = 150
        format.buttonAttributes = [.font: UIFont(name: "Inter-semibold", size: 16)!]
        format.buttonColor = UIColor(named:"uniTrack Light Orange")!
        format.imageSize = CGSize(width: 90, height: 90)
        format.verticalMargin = 0
    
        format.position = EmptyStatePosition(view: EmptyStateViewPosition.top, text: EmptyStateTextPosition.center, image: EmptyStateImagePosition.top)
        //format.position = EmptyStatePosition()
        CollegesCollectionView.emptyState.delegate = self
        CollegesCollectionView.emptyState.dataSource = self
        CollegesCollectionView.emptyState.format = format
        
        DeadlinesCollectionView.emptyState.delegate = self
        DeadlinesCollectionView.emptyState.dataSource = self
        DeadlinesCollectionView.emptyState.format = format
        DeadlinesCollectionView.emptyState.format.imageSize = CGSize(width: 0, height:  0)
        
        UpComingCollectionView.emptyState.delegate = self
        UpComingCollectionView.emptyState.dataSource = self
        UpComingCollectionView.emptyState.format = format
        UpComingCollectionView.emptyState.format.imageSize = CGSize(width: 0, height:  0)
        UpComingCollectionView.emptyState.format.position = EmptyStatePosition(view: EmptyStateViewPosition.top, text: EmptyStateTextPosition.center, image: EmptyStateImagePosition.bottom)
         
    }
}


//MARK: UICollectionview delegate and datasource

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.UpComingCollectionView{
            
            if allTasks?.count == nil{
                UpComingCollectionView.emptyState.show(MainState.upcomingNoData)
            }
            
            if allTasks?.count == 0{
                UpComingCollectionView.emptyState.show(MainState.upcomingNoData)
            }else{
                UpComingCollectionView.emptyState.hide()
            }
            
            return allTasks?.count ?? 0
            
        }else if collectionView == self.DeadlinesCollectionView{
            
            if allDeadlines?.count == nil{
                DeadlinesCollectionView.emptyState.show(MainState.deadlinesNoData)
            }
            
            if allDeadlines?.count == 0{
                DeadlinesCollectionView.emptyState.show(MainState.deadlinesNoData)
            }else{
                DeadlinesCollectionView.emptyState.hide()
            }
            
            return allDeadlines?.count ?? 0
            
        }else{ //CollegeCollectionView
            
            if universities?.count == nil{
                CollegesCollectionView.emptyState.show(MainState.collegesNoData)
            }
            
            if universities?.count == 0{
                CollegesCollectionView.emptyState.show(MainState.collegesNoData)
            }else{
                CollegesCollectionView.emptyState.hide()
            }
            
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
        }else{ //Colleges CollectionView
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/3)
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

//MARK: EMPTYSTATEVIEW DATASOURCE
extension DashboardViewController: EmptyStateDataSource{
    func imageForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> UIImage? {
        switch state as! MainState {
        case .collegesNoData:
            return UIImage(named: "Empty Box Icon")
        case .deadlinesNoData:
            return nil
            //return UIImage(named: "Empty List Icon")
        case .upcomingNoData:
            return nil
        }
    }
    
    func titleForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> String? {
        switch state as! MainState {
        case .collegesNoData:
            return "No Colleges"
        case .deadlinesNoData:
            return "No Deadlines"
        case .upcomingNoData:
            return "No To-dos"
        }
    }
    
    func descriptionForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> String? {
        switch state as! MainState {
        case .collegesNoData:
            return "Looks like you have not added any colleges so far"
        case .deadlinesNoData:
            return "Looks like you do not have any deadlines"
        case .upcomingNoData:
            return "Looks like you do not have any tasks"
        }
    }
    
    func titleButtonForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> String? {
        switch state as! MainState {
        case .collegesNoData:
            return "Add college"
        case .upcomingNoData:
            return nil
        case .deadlinesNoData:
            return nil
        }
        
    }
}

//MARK: EMPTYSTATEVIEW DELEGATE
extension DashboardViewController: EmptyStateDelegate{
    func emptyState(emptyState: EmptyState, didPressButton button: UIButton) {
        
        let storyBoard = UIStoryboard(name: "addCollege", bundle: nil)
        let addCollegeVC = storyBoard.instantiateViewController(withIdentifier: "addCollegeVC") as! AddCollegeViewController
        addCollegeVC.delegate = self
        addCollegeVC.modalPresentationStyle = .overFullScreen
        
        present(addCollegeVC, animated: false, completion: nil)
    }
    
    
}


//doneButtonDelegate
extension DashboardViewController: doneButtonDelegate{
    func doneButtonPressed(name: String, universityChosen: UniversityFromData?, course: String, country: Country) {
        
        let university = University(name: name, course: course, countryIsoCode: country.isoCountryCode, reachType: nil, baseModel: universityChosen)
        
        PersistantService.saveContext()
        
        self.universities?.insert(university, at: 0)
        self.CollegesCollectionView.reloadData()
    }
}

fileprivate enum MainState: CustomState{
    case collegesNoData
    case deadlinesNoData
    case upcomingNoData
}
