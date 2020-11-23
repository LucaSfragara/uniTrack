//
//  CollegeDetailViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 23/11/20.
//

import UIKit

class CollegeDetailViewController: UIViewController {

    @IBOutlet private weak var nameLabel: UILabel!
    weak var university: University?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let university = university else{
            return 
        }
        self.title = university.name
        nameLabel.text = university.name
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
