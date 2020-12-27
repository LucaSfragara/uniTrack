//
//  DeadlinesCollectionViewCell.swift
//  uniTrack
//
//  Created by Luca Sfragara on 28/10/2020.
//

import UIKit

class DeadlinesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var dateSecondaryLabel: UILabel!
    @IBOutlet weak private var datePrimaryLabel: UILabel!
    @IBOutlet weak private var universityLabel: UILabel!
    
    func setup(deadline: Deadline){
        
        let dateFormatter = DateFormatter()
        self.layer.cornerRadius = 10
        dateFormatter.dateFormat = "MMM/d"
        let dateString = dateFormatter.string(from: deadline.date)
        
        let month: String = dateString.components(separatedBy: "/")[0]
        let day: String = dateString.components(separatedBy: "/")[1]
        
        dateSecondaryLabel.text = month
        datePrimaryLabel.text = day
        universityLabel.text = deadline.university.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
