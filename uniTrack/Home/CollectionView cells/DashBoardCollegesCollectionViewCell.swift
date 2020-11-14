//
//  collegesCollectionViewCell.swift
//  uniTrack
//
//  Created by Luca Sfragara on 30/10/2020.
//

import UIKit

class DashboardCollegesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var photoImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var courseLabel: UILabel!
    @IBOutlet weak private var reachImageView: UIImageView!
    
    func setup(university: University){
        
        self.layer.cornerRadius = 10
        self.photoImageView.layer.cornerRadius = 10
        
        nameLabel.text = university.name
        courseLabel.text = university.course
        //photoImageView.image = university.photo
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

