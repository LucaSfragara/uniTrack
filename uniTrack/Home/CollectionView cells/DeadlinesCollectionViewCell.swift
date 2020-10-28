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
    
    func setup(universityName: String, date: Date){
        let dateFormatter = DateFormatter()
        self.layer.cornerRadius = 10
        dateFormatter.dateFormat = "MMM/d"
        let dateString = dateFormatter.string(from: date)
        
        let month: String = dateString.components(separatedBy: "/")[0]
        let day: String = dateString.components(separatedBy: "/")[0]
        
        dateSecondaryLabel.text = month
        datePrimaryLabel.text = day
        universityLabel.text = universityName
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
