//
//  UnisListTableViewCell.swift
//  uniTrack
//
//  Created by Luca Sfragara on 19/10/2020.
//

import UIKit

class UnisListTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var courseLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(universityName: String?, universityCourse: String?){
        guard let name = universityName, let course = universityCourse else{
            return
        }
        
        nameLabel.text = name
        courseLabel.text = course
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
