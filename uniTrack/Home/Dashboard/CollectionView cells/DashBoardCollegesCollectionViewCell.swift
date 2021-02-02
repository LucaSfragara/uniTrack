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
    
    @IBOutlet  private var mainView: UIView!
    
    func setup(university: University?){
        
        self.layer.cornerRadius = 10
        self.photoImageView.layer.cornerRadius = 10
        
        nameLabel.text = university?.name
        courseLabel.text = university?.course
        //photoImageView.image = university.photo
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width-40).isActive = true
    }
    
}

