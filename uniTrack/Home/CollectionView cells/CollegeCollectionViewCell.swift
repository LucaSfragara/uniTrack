//
//  CollegeCollectionViewCell.swift
//  uniTrack
//
//  Created by Luca Sfragara on 14/11/2020.
//

import UIKit

class CollegeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var photoImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var courseLabel: UILabel!
    @IBOutlet weak private var reachLabel: UILabel!
    @IBOutlet weak private var locationLabel: UILabel!
    @IBOutlet weak private var deadlinesLabel: UILabel!
    
    func setup(university: University){
        
        let baseModel = university.baseModel
        self.layer.cornerRadius = 10
        nameLabel.text = university.name
        courseLabel.text = university.course
        locationLabel.text = "U.S., \(baseModel?.state ?? "")"
        reachLabel.text = university.reachType
        deadlinesLabel.text = getDeadlinesLabelText(rawDate: university.deadlines?.last)
        
    }
    
    private func getDeadlinesLabelText(rawDate: Date?) -> String{  //"18 Nov"
        
        guard let rawDate = rawDate else{
            return "No deadlines added"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM/dd"
        let date = dateFormatter.string(from: rawDate)
        return "Next Deadline: \(date)"
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
