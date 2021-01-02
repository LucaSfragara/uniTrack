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
    @IBOutlet weak private var populationField: UITextField!
    @IBOutlet weak private var linkField: UITextField!
    @IBOutlet weak private var schoolTypeSelectorView: UIView!
    
    
    weak var university: University?
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Edit University"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonPressed))
        
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
