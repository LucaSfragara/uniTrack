//
//  UpComingCollectionViewCell.swift
//  uniTrack
//
//  Created by Luca Sfragara on 27/10/2020.
//

import UIKit

//FIXME: FIXME: change name of cell class
class UpComingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var universityNameLabel: UILabel!
    @IBOutlet weak private var taskLabel:UILabel!
    
    func setup(task: Task){
        
        taskLabel.text = task.title
        universityNameLabel.text = task.university.name
        
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.init(named: "uniTrack Blue")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}
