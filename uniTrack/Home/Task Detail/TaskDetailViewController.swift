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
    
    private var state: TaskState = .notEditing //default is sone

    weak var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func mainbuttonPressed(sender: UIButton){ //this can either be 'Edit' or 'Done'
        
        if state == .notEditing{
            
            state = .editing
            mainButton.setTitle("Done", for: .normal)
            
        }else{ //state is editing
            state = .notEditing
            mainButton.setTitle("Edit", for: .normal)
        }
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

