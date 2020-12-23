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
    @IBOutlet weak private var mainButton: UIButton!
    @IBOutlet weak private var deleteButton: UIButton!
    @IBOutlet weak private var taskInfoView: UIView!
    @IBOutlet weak private var editView: UIView!
    @IBOutlet weak private var titleTextField: UITextField!
    @IBOutlet weak private var textTextField: UITextField!
    
    private var state: TaskState = .notEditing //default is sone

    weak var task: Task?
    weak var university: University?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        hideDeleteButton()
        hideEditView()
        taskTitle.text = task?.title
        taskText.text = task?.text
        // Do any additional setup after loading the view.
    }

    
    @IBAction func mainbuttonPressed(sender: UIButton){ //this can either be 'Edit' or 'Done'
        
        if state == .notEditing{
            
            state = .editing
            mainButton.setTitle("Done", for: .normal)
            mainButton.titleLabel?.textAlignment = .center
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
                    self.mainButton.setTitle("Edit", for: .normal)
                    self.mainButton.titleLabel?.textAlignment = .center
                    self.task = updatedTask as! Task
                    self.taskTitle.text = self.task?.title
                    self.taskText.text = self.task?.text
                    
                    self.presentingViewController?.viewWillAppear(true)
                    
                case .failure(let error):
                    //TODO: handle the errors (with alerts maybe?)
                    print(error)
                }
            }
            
        }
    }
    
    private func updateTask(newTitle title: String, newText text: String, completion: @escaping (Result<AddableObject, PersistantStoreError>)->()){
        
        guard let taskToUpdate = self.task, let universityToUpdate = self.university else{return}
        
        DataManager.shared.updateItem(itemToUpdate: taskToUpdate, forUniverity: universityToUpdate, updateValues: ["title": title, "text": text], completion: completion)
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
        taskInfoView.isHidden = false
        editView.isHidden = true
    }
    
    @IBAction private func didPressDeleteButton(){
        let alert = Utilities.createAlertView(title: "Delete Task", message: "Are you sure you want to permanently delete this task?"){
            //datamanager delete task
        }
        
        present(alert, animated: false, completion: nil)
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

fileprivate enum TaskState{
    case editing
    case notEditing
}

