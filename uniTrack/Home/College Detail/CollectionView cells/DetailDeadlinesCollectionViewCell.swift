//
//  DetailDeadlinesCollectionViewCell.swift
//  uniTrack
//
//  Created by Luca Sfragara on 12/12/20.
//

import UIKit

class DetailDeadlinesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var datePrimaryLabel:UILabel!
    @IBOutlet private weak var dateSecondaryLabel: UILabel!
    @IBOutlet private weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.backgroundColor = randomColor() //chooses a random color between light green, light blue and light yellow
        // Initialization code
    }
    
    func setup(deadline: Deadline){
        
        titleLabel.text = deadline.title
        let formattedDate = formatDate(deadline.date)
        datePrimaryLabel.text = formattedDate.0 //day
        dateSecondaryLabel.text = formattedDate.1 //month + year
    }
    private func formatDate(_ date: Date)->(String,String){
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM/d/yyyy"
        let dateString = dateFormatter.string(from: date)
        
        let month: String = dateString.components(separatedBy: "/")[0]
        let day: String = dateString.components(separatedBy: "/")[1]
        let year: String = (dateString.components(separatedBy: "/")[2])
        let trunkedYear: String = "'" + year[year.index(year.startIndex, offsetBy: 2)...]
        return (day, month + " " + trunkedYear)
    }
    
    private func randomColor() -> UIColor{
        let colors = [UIColor(named: "uniTrack Light Green")!, UIColor(named: "uniTrack Light Blue")!, UIColor(named: "uniTrack Light Yellow")!]
        return colors.randomElement()!
    }

}
