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
    
    private var state: TaskState = .notEditing //default is sone

    weak var task: Task?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideDeleteButton()
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
            
        }else{ //state is editing
            state = .notEditing
            hideDeleteButton()
            mainButton.setTitle("Edit", for: .normal)
            mainButton.titleLabel?.textAlignment = .center
        }
    }
    
    private func showDeleteButton(){
        deleteButton.isHidden = false
    }
    private func hideDeleteButton(){
        deleteButton.isHidden = true
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

