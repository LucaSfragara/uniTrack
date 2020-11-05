//
//  MyCollegesViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 31/10/2020.
//

import UIKit

class MyCollegesViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didPressAddButton(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "addCollege", bundle: nil)
        let addCollegeVC = storyBoard.instantiateViewController(withIdentifier: "addCollegeVC") as! AddCollegeViewController
        addCollegeVC.delegate = self
        addCollegeVC.modalPresentationStyle = .overFullScreen
        
        present(addCollegeVC, animated: false, completion: nil)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension MyCollegesViewController: doneButtonDelegate{
    func doneButtonPressed(universityName: String, course: String) {
        return
    }
}
