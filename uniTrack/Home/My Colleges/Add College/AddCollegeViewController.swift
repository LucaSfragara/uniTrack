//
//  AddItemViewController.swift
//  authTest
//
//  Created by Massimiliano Sfragara on 22/06/2020.
//  Copyright © 2020 Sfra.org. All rights reserved.
//

import UIKit
import CoreData
import DropDown

class AddCollegeViewController: UIViewController {
    
    @IBOutlet weak var cardView: DesignableView!
    @IBOutlet weak var dimmerView: UIView!
    @IBOutlet weak var cardViewTopCostraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var courseField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    
    @IBOutlet weak var doneButton: DesignableButton!
    
    
    private var universityChosen: UniversityFromData?
    
    private var countryChosen: Country?{
        didSet{
            self.countryField.text = "\(countryChosen?.flag ?? "") \(countryChosen?.name ?? "")"
        }
    }

    var delegate: doneButtonDelegate?
    
    var cardPanStartingTopConstant : CGFloat = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.disableButton()
        
        //fetchedResultController?.delegate = self
        nameField.addTarget(self, action: #selector(handleNameTextChanged), for: .editingChanged)
        countryField.addTarget(self, action: #selector(handleCountryTextChanged), for: .editingChanged)
        
        //Add target to check when to enable button
        [courseField, countryField, nameField].forEach{$0?.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)}
        
        
        cardView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        if let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.size.height,
           let bottomPadding = UIApplication.shared.windows.first?.safeAreaInsets.bottom {
            
          cardViewTopCostraint.constant = safeAreaHeight + bottomPadding
            
        }
        dimmerView.alpha = 0.0
        
        //setup textfield
        nameField.returnKeyType = .done
        courseField.returnKeyType = .done
        countryField.returnKeyType = .done
        nameField.delegate = self
        courseField.delegate = self
        countryField.delegate = self
        
        //Observe keyboards appearing
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShown(_:)), name: UIControl.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide(_:)), name: UIControl.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc private func handleKeyboardShown(_ notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = 0 - keyboardSize.height
            }
    }
    
    @objc private func handleKeyboardHide(_ notification: NSNotification){
        self.view.frame.origin.y = 0
    }
    
    @objc  private func handleTextChanged(){
    
        if let course = self.courseField.text, course.isEmpty == false,
           let name = self.nameField.text, name.isEmpty == false,
           let country = self.countryField.text, country.isEmpty == false
         {
            doneButton.enableButton()
         }else {
            doneButton.disableButton()
         }
            
    }
    
    
    @objc private func handleCountryTextChanged(){
        
        guard let text = countryField.text else{return}
        
        let filteredCountries = Utilities.countryList().filter{
            $0.name.lowercased().contains(text.lowercased())
        }
        
        handleCountryDropDownMenu(data: filteredCountries)
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
    
        guard let delegate = self.delegate,
           let course = self.courseField.text, course.isEmpty == false,
           let name = self.nameField.text, name.isEmpty == false,
           let country = self.countryChosen
           else {return}
           
        delegate.doneButtonPressed(name: name, universityChosen: universityChosen, course: course, country: country)
        hideCard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showCard()
    }
    
    @IBAction func tapGestureRecognizer (_ tapRecognizer: UITapGestureRecognizer ){
        
        hideCard()
        
    }
    
    
    @IBAction func panGestureRecognizer(_ panRecognizer: UIPanGestureRecognizer){
       
        let translation = panRecognizer.translation(in: self.view)
      
        guard let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.size.height,
            let bottomPadding = UIApplication.shared.windows.first?.safeAreaInsets.bottom else{print("safe Area height or bottom padding not available"); return}
        
        switch panRecognizer.state {
        case .began:
            cardPanStartingTopConstant = cardViewTopCostraint.constant
        case .changed:
            if cardPanStartingTopConstant + translation.y > (safeAreaHeight+bottomPadding)/2.0{
                cardViewTopCostraint.constant = cardPanStartingTopConstant + translation.y
            }
        case .ended:
            if cardPanStartingTopConstant + translation.y > ((safeAreaHeight + bottomPadding) * (3/4)){
                
                hideCard()
                    
            }
            else{
                showCard()
            }
        default:
            break
        }
    }
    
    @objc func handleNameTextChanged (){
        
        guard let text = nameField.text else {return}
        

        if !text.trimmingCharacters(in: .whitespaces).isEmpty {
            if text.count > 3{
                fetchUniversitiesFromData(withNameContaining: text)
            }
        }
    }
    
    private func fetchUniversitiesFromData(withNameContaining inputText: String?){
        
        let fetchRequest = NSFetchRequest<UniversityFromData>(entityName: "UniversityFromData")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            if let text = inputText {
                let fetchPredicate = NSPredicate(format: "name CONTAINS[c] %@", text)
                fetchRequest.predicate = fetchPredicate
            }
        
            do {
                
                let result = try PersistantService.context.fetch(fetchRequest)
                
                DispatchQueue.main.async {
                    self.handleUniversityDropDownMenu(data: result)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
       
    }
    
    private func handleCountryDropDownMenu(data: [Country]){
        
        let datasource = data.map{"\($0.flag ?? "") \($0.name)"}
        let dropDown = DropDown()
        
        dropDown.dataSource = datasource
        
        dropDown.selectionAction = { [weak self] (index: Int, item : String) in
            self?.countryField.text = data[index].name
            self?.countryChosen = data[index]
        }
        
        dropDown.anchorView = countryField
        dropDown.direction = .bottom
        dropDown.cornerRadius = 10
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.show()

    }
    
    private func handleUniversityDropDownMenu(data: [UniversityFromData]){
        
        var universityNames = [String]()
        for university in data{
            universityNames.append(university.name ?? "")
        }
        let dropDown = DropDown()
        dropDown.dataSource = universityNames
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.nameField.text = item
            self?.universityChosen = data[index]
            if let isoCountryCode = data[index].isoCountryCode{
                self?.countryChosen = Country(fromIsoCountryCode: isoCountryCode)
            }
        }
        
        dropDown.anchorView = nameField
        dropDown.direction = .bottom
        dropDown.cornerRadius = 10
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.show()
        
    }

}


//MARK: animtions
extension AddCollegeViewController{
    
    private func hideCard(){
        
        self.view.layoutIfNeeded()
        
        if let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.size.height,
           let bottomPadding = UIApplication.shared.windows.first?.safeAreaInsets.bottom {
            
            cardViewTopCostraint.constant = (safeAreaHeight + bottomPadding)
            
        }
        
        let hideCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn){
            
            self.view.layoutIfNeeded()
            self.dimmerView.alpha = 0
        }
        
        hideCard.addCompletion(){position in
            
            if position == .end { //animation has ended
                
                self.dismiss(animated: false, completion: nil)
                
            }
            
        }
        
        hideCard.startAnimation()
        
    }
    
    private func showCard(){
        
        self.view.layoutIfNeeded()
        
        if let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.size.height,
           let bottomPadding = UIApplication.shared.windows.first?.safeAreaInsets.bottom {
            
            cardViewTopCostraint.constant = (safeAreaHeight + bottomPadding)/2.2
            
        }
        
        let cardAnimation = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn){
            
            self.view.layoutIfNeeded()
            self.dimmerView.alpha = 0.7
        }
        
        cardAnimation.startAnimation()
        
    }
    
    
}
//MARK: TEXTFIELD DELEGATE
extension AddCollegeViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}



//MARK: PROTOCOLS
protocol doneButtonDelegate{
    
    func doneButtonPressed(name: String, universityChosen: UniversityFromData?, course: String, country: Country)
    
}

