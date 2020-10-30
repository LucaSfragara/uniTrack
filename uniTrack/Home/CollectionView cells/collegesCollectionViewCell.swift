//
//  collegesCollectionViewCell.swift
//  uniTrack
//
//  Created by Luca Sfragara on 30/10/2020.
//

import UIKit

class CollegesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var photoImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var courseLabel: UILabel!
    @IBOutlet weak private var reachImageView: UIImageView!
    
    func setup(photoImage: UIImage?, name: String, course: String, schoolType: reachType){
        
        self.layer.cornerRadius = 10
        self.photoImageView.layer.cornerRadius = 10
        
        nameLabel.text = name
        courseLabel.text = course
        reachImageView.image = UIImage(named: schoolType.rawValue)
        photoImageView.image = photoImage
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

enum reachType: String{
    case safety = "safetySchoolIcon"
    case match = "matchSchoolcon"
    case reach = "reachSchoolIcon"
}
