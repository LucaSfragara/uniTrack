//
//  MyCollegesViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 31/10/2020.
//

import UIKit
import CoreData

class MyCollegesViewController: UIViewController {

    @IBOutlet private weak var CollegesCollectioView: UICollectionView!
    
    var universities: [University]?
    var searchController: UISearchController?
    
    private var isSearchBarEmpty: Bool{
        return searchController?.searchBar.text?.isEmpty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            return 0
        }
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
    
}

extension MyCollegesViewController: doneButtonDelegate{
    
    func doneButtonPressed(name: String, universityChosen: UniversityFromData?, course: String, country: Country) {
        
        let university = University(name: name, course: course, countryIsoCode: country.isoCountryCode, reachType: nil, baseModel: universityChosen)
        
        PersistantService.saveContext()
        
        self.universities?.insert(university, at: 0)
        self.CollegesCollectioView.reloadData()
        
    }
}
