//
//  DeadlineDetailViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 18/12/20.
//

import UIKit

class DeadlineDetailViewController: UIViewController {

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var mainButton: UIButton!
    @IBOutlet weak private var deleteButton: UIButton!
    @IBOutlet weak private var infoView: UIView!
    
    @IBOutlet weak private var editView: UIView!
    @IBOutlet weak private var titleField: UITextField!
    @IBOutlet weak private var datePicker: UIDatePicker!

    weak var deadline: Deadline?
    weak var university: University?
    
    private var state: deadlineState = .notEditing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.minimumDate = Date()
        titleLabel.text = deadline?.title
        dateLabel.text = deadline?.date.toString()
        hideDeleteButton()
        hideEditView()
        
        // Do any additional setup after loading the view.
    }

    //FIXME: FIX: to be removed when navigationController is used to push VC
    override func viewWillDisappear(_ animated: Bool) {
        //This makes the collegeDetailViewController fetch the university with the updated task
        self.presentingViewController?.viewWillAppear(true)
    }
    
    
    @IBAction func mainbuttonPressed(sender: UIButton){ //this can either be 'Edit' or 'Done'
        
        if state == .notEditing{
            //start editing
            state = .editing
            mainButton.setTitle("Done", for: .normal)
            mainButton.titleLabel?.textAlignment = .center
            showDeleteButton()
            showEditView()
            
            
        }else{ //state is editing
            
            guard let title = titleField.text, title.isEmpty == false else{
                return
            }
            
            updateDeadline(newTitle: title, newDate: datePicker.date){result in
                
                switch result{
                case .success(let updatedDeadline):
                    
                    self.hideEditView()
                    self.state = .notEditing
                    self.hideDeleteButton()
                    self.mainButton.setTitle("Edit", for: .normal)
                    self.mainButton.titleLabel?.textAlignment = .center
                    self.deadline =  updatedDeadline as? Deadline
                    self.titleLabel.text = self.deadline?.title
                    self.dateLabel.text = self.deadline?.date.toString()
                    
                case .failure(let error):
                    //TODO: handle the errors (with alerts maybe?)
                    print(error)
                }
            }
            
        }
    }
    
    @IBAction private func didPressDeleteButton(){
        let alert = Utilities.createAlertView(title: "Delete Deadline", message: "Are you sure you want to permanently delete this deadline?"){
            guard let deadlineToDelete = self.deadline, let university = self.university else{return}
            DataManager.shared.deleteItem(itemToDelete: deadlineToDelete, forUniversity: university){ result in
                switch result {
                case .success(_):
                    self.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    //TODO: TODO: handle error
                    print(error)
                }
            }
        }
        present(alert, animated: false, completion: nil)
    }
    
    private func showDeleteButton(){
        deleteButton.isHidden = false
    }
    private func hideDeleteButton(){
        deleteButton.isHidden = true
    }
    
    private func showEditView(){
        
        infoView.isHidden = true
        editView.isHidden = false
        titleField.text = deadline?.title
        datePicker.date = deadline!.date
        
    }
    
    private func hideEditView(){
        infoView.isHidden = false
        editView.isHidden = true
    }
    
    private func updateDeadline(newTitle title: String, newDate date: Date, completion: @escaping (Result<AddableObject, PersistantStoreError>)->()){
    
        guard let deadlineToUpdate = deadline, let universityToUpdate = university else {return}
        
        DataManager.shared.updateItem(itemToUpdate: deadlineToUpdate, forUniverity: universityToUpdate, updateValues: ["title": title, "date": date], completion: completion)
    }
    
    @IBAction func didPressBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

fileprivate enum deadlineState{
    case editing
    case notEditing
}


//MARK: Date.toString extension
extension Date{
    func toString(dateFormat: String = "EEEE, MMM d, yyyy") -> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
