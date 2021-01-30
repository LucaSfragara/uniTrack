//
//  MyCollegesViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 31/10/2020.
//

import UIKit
import CoreData
import EmptyStateKit

class MyCollegesViewController: UIViewController {

    @IBOutlet private weak var CollegesCollectioView: UICollectionView!
    
    var universities: [University]?
    var searchController: UISearchController?

    private var currentState: VCCurrentState = .normal
    
    private var isSearchBarEmpty: Bool{
        return searchController?.searchBar.text?.isEmpty ?? true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup emptystate view
        var format = EmptyStateFormat()
        
        view.emptyState.delegate = self
        view.emptyState.dataSource = self
        
        format.titleAttributes = [.font: UIFont(name: "Inter-bold", size: 26)!, .foregroundColor: UIColor.black]
        format.descriptionAttributes = [.font: UIFont(name: "Inter-medium", size: 16)!, .foregroundColor: UIColor(named: "uniTrack secondary label color")]
        format.backgroundColor = UIColor(named: "uniTrack Light Grey")!
        format.buttonWidth = 150
        format.buttonAttributes = [.font: UIFont(name: "Inter-semibold", size: 16)!]
        format.buttonColor = UIColor(named:"uniTrack Light Orange")!
        view.emptyState.format = format
        
        CollegesCollectioView.delegate = self
        CollegesCollectioView.dataSource = self
        setUpSearchController()
       
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        DataManager.shared.getSortedUniversities(byDateAscending: false){[weak self ]result in
            
            switch result {
            case .failure(let error):
                //TODO: handle error appropriately
                print(error)
            case .success(let universities):
                self?.universities = universities
                self?.CollegesCollectioView.reloadData()
            }
        }
    }
    
    @IBAction func didPressAddButton(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "addCollege", bundle: nil)
        let addCollegeVC = storyBoard.instantiateViewController(withIdentifier: "addCollegeVC") as! AddCollegeViewController
        addCollegeVC.delegate = self
        addCollegeVC.modalPresentationStyle = .overFullScreen
        
        present(addCollegeVC, animated: false, completion: nil)
    }
    
    private func setUpSearchController(){
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        
        searchController?.searchBar.placeholder = "Search in My Colleges"
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

//MARK: Search controller delegate
extension MyCollegesViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        currentState = .searching
        let searchText = isSearchBarEmpty ? nil : searchController.searchBar.text
        DataManager.shared.getUniversities(withNameContaining: searchText){[weak self] result in
            switch result {
            case .failure(let error):
                //TODO: handle error appropriately
                print(error)
            case .success(let universities):
                self?.universities = universities
                self?.CollegesCollectioView.reloadData()
                
            }
        }
        
    }
    
    
}

//MARK: CollectionView delegate and datasource

extension MyCollegesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let universities = universities else {
            if self.currentState == .normal{
                self.view.emptyState.show(MainState.noColleges)
            }else if self.currentState == .searching{
                self.view.emptyState.show(MainState.noSearchResult)
            }
            return 0
        }
        
        if universities.count == 0 {
            if self.currentState == .normal{
                self.view.emptyState.show(MainState.noColleges)
            }else if self.currentState == .searching{
                self.view.emptyState.show(MainState.noSearchResult)
            }
        }else{
            self.view.emptyState.hide()
        }
        currentState = .normal
        return universities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collegeCellID", for: indexPath) as! CollegeCollectionViewCell
        
        guard let universities = universities else {
            return cell
        }
        cell.setup(university: universities[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let universitySelected = universities?[indexPath.row]
        let storyboard = UIStoryboard(name: "CollegeDetail", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "CollegeDetailVCID") as! CollegeDetailViewController
        detailVC.university = universitySelected
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/4)
    }
    
}

//MARK: DONE BUTTON DELEGATE
extension MyCollegesViewController: doneButtonDelegate{
    
    func doneButtonPressed(name: String, universityChosen: UniversityFromData?, course: String, country: Country) {
        
        let university = University(name: name, course: course, countryIsoCode: country.isoCountryCode, reachType: nil, baseModel: universityChosen)
        
        PersistantService.saveContext()
        
        self.universities?.insert(university, at: 0)
        self.CollegesCollectioView.reloadData()
        
    }
}
//MARK: EMPTY STATE DELEGATE
extension MyCollegesViewController: EmptyStateDelegate{
    func emptyState(emptyState: EmptyState, didPressButton button: UIButton) {
        let storyBoard = UIStoryboard(name: "addCollege", bundle: nil)
        let addCollegeVC = storyBoard.instantiateViewController(withIdentifier: "addCollegeVC") as! AddCollegeViewController
        addCollegeVC.delegate = self
        addCollegeVC.modalPresentationStyle = .overFullScreen
        
        present(addCollegeVC, animated: false, completion: nil)
    }
}


//MARK: EMPTY STATE DATASOURCE
extension MyCollegesViewController: EmptyStateDataSource{
    
    func imageForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> UIImage? {
        switch state as! MainState{
        case .noColleges:
            return UIImage(named: "Empty Box Icon")
        case .noSearchResult:
            return UIImage(named: "Empty Box Icon")
        }
        return nil
    }
    
    func titleForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> String? {
        switch state as! MainState{
        case .noColleges:
            return "No Colleges"
        case .noSearchResult:
            return "No colleges found"
        }
    }
    
    func descriptionForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> String? {
        switch state as! MainState{
        case .noColleges:
            return "Looks like you have not added any colleges so far"
        case .noSearchResult:
            return "Look like no colleges were found matching your search"
        }
    }
    
    func titleButtonForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> String? {
        switch state as! MainState{
        case .noColleges:
            return "Add a college"
        case .noSearchResult:
            break
        }
        return nil
    }
    
}

fileprivate enum VCCurrentState{
    case normal
    case searching
}

fileprivate enum MainState: CustomState{
    case noColleges
    case noSearchResult
}
