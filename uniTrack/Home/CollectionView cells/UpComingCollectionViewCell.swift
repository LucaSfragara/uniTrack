//
//  UpComingCollectionViewCell.swift
//  uniTrack
//
//  Created by Luca Sfragara on 27/10/2020.
//

import UIKit

class UpComingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var universityNameLabel: UILabel!
    @IBOutlet weak private var taskLabel:UILabel!
    
    func setup(universityName: String, task: String){
        universityNameLabel.text = universityName
        taskLabel.text = task
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.init(named: "uniTrack Light Blue")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}
