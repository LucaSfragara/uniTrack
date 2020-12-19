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

    @IBOutlet weak var doneButton: DesignableButton!
    
    
    
    private var universityChosen: UniversityFromData?

    var delegate: doneButtonDelegate?
    
   
    
    var cardPanStartingTopConstant : CGFloat = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        doneButton.isEnabled = false // set done button state to disabled by default
        doneButton.alpha = 0.6
        
        //fetchedResultController?.delegate = self
        
        nameField.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        
        cardView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        if let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.size.height,
           let bottomPadding = UIApplication.shared.windows.first?.safeAreaInsets.bottom {
            
          cardViewTopCostraint.constant = safeAreaHeight + bottomPadding
            
        }
        dimmerView.alpha = 0.0
        
        
        
    }
    
    
    @IBAction func didTapDoneButton(_ sender: Any) {
    
        if let delegate = self.delegate, let course = self.courseField.text, let name = self.nameField.text{
            delegate.doneButtonPressed(name: name, universityChosen: universityChosen, course: course)
            hideCard()
        }
        
        
        
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
    
    @objc func handleTextChanged (){
        
        guard let text = nameField.text else {return}
        

        if !text.trimmingCharacters(in: .whitespaces).isEmpty {
            if text.count > 3{
                fetchUniversitiesFromData(withNameContaining: text)
            }
            doneButton.isEnabled = true
            doneButton.alpha = 1
        }else{
        
            doneButton.alpha = 0.6
            doneButton.isEnabled = false
    
        }
    }
    
    private func fetchUniversitiesFromData(withNameContaining inputText: String?){
        
        let fetchRequest = NSFetchRequest<UniversityFromData>(entityName: "UniversityFromData")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let text = inputText {
            let fetchPredicate = NSPredicate(format: "name CONTAINS[c] %@", text)
            fetchRequest.predicate = fetchPredicate
        }
    
        do {
            let result = try PersistantService.context.fetch(fetchRequest)
            handleDropDownMenu(data: result)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func handleDropDownMenu(data: [UniversityFromData]){
        
        var universityNames = [String]()
        for university in data{
            universityNames.append(university.name ?? "")
        }
        let dropDown = DropDown()
        dropDown.dataSource = universityNames
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.nameField.text = item
            self?.universityChosen = data[index]
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


protocol doneButtonDelegate{
    
    func doneButtonPressed(name: String, universityChosen: UniversityFromData?, course: String)
}

