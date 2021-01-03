//
//  CollegeEditViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 30/12/20.
//

import UIKit

class CollegeEditViewController: UIViewController {

    
    @IBOutlet weak private var nameField: UITextField!
    @IBOutlet weak private var courseField: UITextField!
    @IBOutlet weak private var countryField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak private var populationField: UITextField!
    @IBOutlet weak private var linkField: UITextField!
    @IBOutlet weak private var schoolTypeSelectorView: OptionSelectionView!
    
    weak var university: University?
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Edit University"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonPressed))
        
        nameField.text = university?.name
        courseField.text = university?.course
        stateField.text = university?.baseModel?.state
        populationField.text = university?.baseModel?.population
        schoolTypeSelectorView.selectedOption = (university?.reachType).map { University.ReachType(rawValue: $0)!}
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func doneButtonPressed(){
        
        guard let name = nameField.text, let course = courseField.text else {return}
                
        updateUniversity(newName: name, newCourse: course, newReachType: schoolTypeSelectorView.selectedOption, newPopulation: Int(populationField.text ?? "a"), newState: stateField.text){[weak self] result in //a make the Int conversion return nil, hence the value is not updated
            
            switch result{
            case .success(let updatedUniversity):
                guard let presentingVC = self?.navigationController?.viewControllers[(self?.navigationController?.viewControllers.count)!-2] as? CollegeDetailViewController else{
                    return
                }
                
                presentingVC.university = updatedUniversity
                self?.navigationController?.popViewController(animated: true)
                
            //TODO: TODO: handle error
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction private func didPressDeleteButton(){
        guard let university = university else{return}
        
        let alertView = Utilities.createAlertView(title: "Delete University", message: "Are you sure you want to permanently delete the this university"){
            DataManager.shared.deleteUniversity(universityToDelete: university){[weak self] result in
                
                switch result{
                case .success(let _):
                    self?.navigationController?.popToRootViewController(animated: true)
                //TODO: TODO: Error
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        present(alertView, animated: true, completion: nil)
    }
    
    private func updateUniversity(newName name: String,
                                  newCourse course: String,
                                  newReachType reachType: University.ReachType?,
                                  newPopulation population: Int?,
                                  newState state: String?,
                                  completion: @escaping (Result<University, PersistantStoreError>) -> ()){
        
        guard let university = self.university else{return}
        
        DataManager.shared.updateUniversity(universityToUpdate: university, updateValues: [
            "name" : name,
            "course" : course,
            "reachtype": reachType,
            "population" : population,
            "state" : state
        ], completion: completion)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
