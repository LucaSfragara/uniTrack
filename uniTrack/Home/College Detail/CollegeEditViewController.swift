//
//  CollegeEditViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 30/12/20.
//

import UIKit
import DropDown
import SwiftSpinner

class CollegeEditViewController: UIViewController {

    
    @IBOutlet weak private var nameField: UITextField!
    @IBOutlet weak private var courseField: UITextField!
    @IBOutlet weak private var countryField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak private var populationField: UITextField!
    @IBOutlet weak private var linkField: UITextField!
    @IBOutlet weak private var schoolTypeSelectorView: OptionSelectionView!
    
    
    weak var university: University?
    private var countryChosen:  Country?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Edit University"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonPressed))
        
        countryChosen = university?.country
        nameField.text = university?.name
        courseField.text = university?.course
        countryField.text = "\(university?.country?.flag ?? "") \(university?.country?.isoCountryCode ?? "")"
        stateField.text = university?.baseModel?.state
        populationField.text = university?.baseModel?.population
        schoolTypeSelectorView.selectedOption = (university?.reachType).map { University.ReachType(rawValue: $0)!}
        linkField.text = university?.link
        
        countryField.addTarget(self, action: #selector(handleCountryTextChanged), for: .editingChanged)
        
        //setup textfields delegate
        
        for textField in allTextField(view: self.view){
                textField.returnKeyType = .done
                textField.delegate = self
        }
        
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
        
        guard let name = nameField.text, let course = courseField.text,  let country = countryChosen else {return}
        updateUniversity(newName: name,
                         newCourse: course,
                         newReachType: schoolTypeSelectorView.selectedOption,
                         newPopulation: Int(populationField.text ?? "a"),
                         newState: stateField.text,
                         newCountry: country,
                         newLink: linkField.text
        ){[weak self] result in //a make the Int conversion return nil, hence the value is not updated
            
            switch result{
            case .success(let updatedUniversity):
                DispatchQueue.main.async {
                    guard let presentingVC = self?.navigationController?.viewControllers[(self?.navigationController?.viewControllers.count)!-2] as? CollegeDetailViewController else{
                        return
                    }
                    presentingVC.university = updatedUniversity
                    self?.navigationController?.popViewController(animated: true)
                }
                
                
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
    
    @objc private func handleCountryTextChanged(){
        
        guard let text = countryField.text else{return}
        
        let filteredCountries = Utilities.countryList().filter{
            $0.name.lowercased().contains(text.lowercased())
        }
        
        handleCountryDropDownMenu(data: filteredCountries)
    }
    
    private func handleCountryDropDownMenu(data: [Country]){
        
        let datasource = data.map{"\($0.flag ?? "") \($0.name)"}
        let dropDown = DropDown()
        
        dropDown.dataSource = datasource
        
        dropDown.selectionAction = { [weak self] (index: Int, item : String) in
            self?.countryField.text = "\(data[index].flag ?? "") \(data[index].isoCountryCode)"
            self?.countryChosen = data[index]
        }
        
        dropDown.anchorView = countryField
        dropDown.direction = .bottom
        dropDown.cornerRadius = 10
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.show()

    }
    
    private func updateUniversity(newName name: String,
                                  newCourse course: String,
                                  newReachType reachType: University.ReachType?,
                                  newPopulation population: Int?,
                                  newState state: String?,
                                  newCountry country: Country,
                                  newLink link: String?,
                                  completion: @escaping (Result<University, PersistantStoreError>) -> ()){
        
        guard let university = self.university else{return}
        
        //check if link is valid
        if let link = link{
            DispatchQueue.main.async {
                SwiftSpinner.shared.outerColor = UIColor(named: "uniTrack Light Orange")
                SwiftSpinner.show("Checking if link is valid...")
                self.view.isUserInteractionEnabled = false
                
            }
            
            Utilities.pingURL(string: link){result in
                
                    switch result{
                    case .success(let responseCode):
                        
                        print("Link is valid: \(responseCode)")
                        DataManager.shared.updateUniversity(universityToUpdate: university, updateValues: [
                            "name" : name,
                            "course" : course,
                            "reachtype": reachType,
                            "population" : population,
                            "state" : state,
                            "isoCountryCode": country.isoCountryCode,
                            "link": link
                        ], completion: completion)
                        
                        DispatchQueue.main.async {
                            SwiftSpinner.hide()
                            self.view.isUserInteractionEnabled = true
                        }
                        
                        return
                        
                    case .failure(let error):
                        print("Error in the link: \(error)")
                        completion(.failure(.linkIsNotValid))
                        
                        DispatchQueue.main.async {
                            SwiftSpinner.hide()
                            self.view.isUserInteractionEnabled = true
                            let alertView = Utilities.createAlertView(title: "Error in the link",message: "Oops, it looks like the link you provided is not valid", button1Title: "Try Again", button2title: nil){}
                            self.present(alertView, animated: true, completion: nil)
                        }
                        
                        return
                    }
                }
        }
        
        DataManager.shared.updateUniversity(universityToUpdate: university, updateValues: [
            "name" : name,
            "course" : course,
            "reachtype": reachType,
            "population" : population,
            "state" : state,
            "isoCountryCode": country.isoCountryCode,
            "link": nil
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
    
    func allTextField(view: UIView) -> [UITextField] {
            var subviewArray = [UITextField]()
            for subview in view.subviews {
                subviewArray += self.allTextField(view: subview)
                if let subview = subview as? UITextField{
                    subviewArray.append(subview)
                }
            }
            return subviewArray
        }

}

//MARK: TEXTFIELD DELEGATE

extension CollegeEditViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
