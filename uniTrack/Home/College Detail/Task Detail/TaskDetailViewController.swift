//
//  TaskDetailViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 18/12/20.
//

import UIKit

class TaskDetailViewController: UIViewController {

    @IBOutlet weak private var taskTitle: UILabel!
    @IBOutlet weak private var taskText: UILabel!
    @IBOutlet weak private var deleteButton: UIButton!
    @IBOutlet weak private var taskInfoView: UIView!
    @IBOutlet weak private var editView: UIView!
    @IBOutlet weak private var titleTextField: UITextField!
    @IBOutlet weak private var textTextField: UITextField!
    @IBOutlet weak private var taskNotesLabel: UILabel!
    
    @IBOutlet weak private var universityLabel: UILabel!
    
    private lazy var doneBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(mainButtonPressed))
    private lazy var editBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(mainButtonPressed))
    
    private var state: TaskState?{
        didSet{
            
            switch state!{
            case .editing:
                navigationItem.rightBarButtonItem = doneBarButtonItem
            case .notEditing:
                navigationItem.rightBarButtonItem = editBarButtonItem
            }
        }
    }

    weak var task: Task?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.isNavigationBarHidden = false
        state = .notEditing

        hideDeleteButton()
        hideEditView()
        taskTitle.text = task?.title
        taskText.text = task?.text
        universityLabel.text = task?.university.name
        
        taskTitle.layer.cornerRadius = 15
        taskTitle.layer.shadowColor = UIColor(named: "uniTrack Light Blue")!.cgColor
        taskTitle.layer.shadowOpacity = 1
        taskTitle.layer.masksToBounds = true
        taskTitle.layer.shadowOffset = CGSize(width: 0, height: 0)
        taskTitle.layer.shouldRasterize = true
        taskTitle.layer.rasterizationScale = UIScreen.main.scale
        
        taskText.layer.cornerRadius = 15
        taskText.layer.masksToBounds = true
        
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = true
        //This makes the collegeDetailViewController fetch the university with the updated task - not needed anymore cause of vc being pushed
        //self.presentingViewController?.viewWillAppear(true)
        
    }
    
     @objc func mainButtonPressed(sender: UIButton){ //this can either be 'Edit' or 'Done'
        
        if state == .notEditing{
            
            state = .editing
            showDeleteButton()
            showEditView()
            
        }else{ //state is editing
            
            guard let title = titleTextField.text, let text = textTextField.text, title.isEmpty == false else{
                return
            }
            
            updateTask(newTitle: title, newText: text){result in
                switch result{
                case .success(let updatedTask):

                    self.hideEditView()
                    self.state = .notEditing
                    self.hideDeleteButton()

                    self.task = updatedTask as? Task
                    self.taskTitle.text = self.task?.title
                    self.taskText.text = self.task?.text
                    
                case .failure(let error):
                    //TODO: handle the errors (with alerts maybe?)
                    print(error)
                }
            }
            
        }
    }
    
    private func updateTask(newTitle title: String, newText text: String, completion: @escaping (Result<AddableObject, PersistantStoreError>)->()){
        
        guard let taskToUpdate = self.task else{return}
        
        DataManager.shared.updateItem(itemToUpdate: taskToUpdate, updateValues: ["title": title, "text": text], completion: completion)
    }
    
    private func showDeleteButton(){
        deleteButton.isHidden = false
    }
    private func hideDeleteButton(){
        deleteButton.isHidden = true
    }
    
    private func showEditView(){
        
        taskInfoView.isHidden = true
        editView.isHidden = false
        textTextField.text = task?.text
        titleTextField.text = task?.title
        
    }
    private func hideEditView(){
        
        if task?.text == nil{
            taskNotesLabel.isHidden = true
        }else{
            taskNotesLabel.isHidden = false
        }
        
        if task!.text.isEmpty{
            taskNotesLabel.isHidden = true
        }else{
            taskNotesLabel.isHidden = false
        }
        
        taskInfoView.isHidden = false
        editView.isHidden = true
    }
    
    @IBAction private func didPressDeleteButton(){
        let alert = Utilities.createAlertView(title: "Delete Task", message: "Are you sure you want to permanently delete this task?"){
            guard let taskToDelete = self.task else{return}
            DataManager.shared.deleteItem(itemToDelete: taskToDelete){ result in
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

fileprivate enum TaskState{
    case editing
    case notEditing
}

