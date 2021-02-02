//
//  DeadlineDetailViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 18/12/20.
//

import UIKit

class DeadlineDetailViewController: UIViewController {

    @IBOutlet weak private var deleteButton: UIButton!
    @IBOutlet weak private var infoView: UIView!
    @IBOutlet weak private var editView: UIView!
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var universityLabel: UILabel!
    
    @IBOutlet weak private var titleField: UITextField!
    @IBOutlet weak private var datePicker: UIDatePicker!

    weak var deadline: Deadline?
    
    private lazy var doneBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(mainButtonPressed))
    private lazy var editBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(mainButtonPressed))
    
    private var state: deadlineState?{
        didSet{
            
            switch state!{
            case .editing:
                navigationItem.rightBarButtonItem = doneBarButtonItem
            case .notEditing:
                navigationItem.rightBarButtonItem = editBarButtonItem
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.isNavigationBarHidden = false
        state = .notEditing
        
        datePicker.minimumDate = Date()
        titleLabel.text = deadline?.title
        dateLabel.text = deadline?.date.toString()
        universityLabel.text = deadline?.university.name
        
        hideDeleteButton()
        hideEditView()
    
        // Do any additional setup after loading the view.
    }

    //FIXME: FIX: to be removed when navigationController is used to push VC
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.isNavigationBarHidden = true
        //This makes the collegeDetailViewController fetch the university with the updated task
        //Not needed anymore cause of VC being pushed rather than presented
       self.presentingViewController?.viewWillAppear(true)
    }
    
    @objc func mainButtonPressed(){ //this can either be 'Edit' or 'Done'
        
        if state == .notEditing{
            //start editing
            state = .editing
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
            guard let deadlineToDelete = self.deadline else{return}
            DataManager.shared.deleteItem(itemToDelete: deadlineToDelete){ result in
                switch result {
                case .success(_):
                    self.navigationController?.popViewController(animated: true)
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
    
        guard let deadlineToUpdate = deadline else {return}
        
        DataManager.shared.updateItem(itemToUpdate: deadlineToUpdate, updateValues: ["title": title, "date": date], completion: completion)
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
