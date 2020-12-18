//
//  DetailTodosCollectionViewCell.swift
//  uniTrack
//
//  Created by Luca Sfragara on 13/12/20.
//

import UIKit
import SimpleCheckbox

class DetailTodosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: DesignableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var checkbox: Checkbox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCheckbox()
        mainView.backgroundColor = randomColor()
    }
    
    func setup(task: Task, completion: @escaping (Bool) ->()){ //replace parameters with task object
        self.titleLabel.text = task.title
        self.secondaryLabel.text = task.text
        checkbox.valueChanged = {(isChecked) in
            if isChecked{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    private func setupCheckbox(){
        
        checkbox.checkedBorderColor = .black
        checkbox.uncheckedBorderColor = .black
        checkbox.borderStyle = .square
        checkbox.checkmarkStyle = .tick
        checkbox.checkmarkSize = 0.6
        checkbox.checkmarkColor = .black
        checkbox.borderCornerRadius = 3
    }
    
    private func randomColor() -> UIColor{
        let colors = [UIColor(named: "uniTrack Light Green")!, UIColor(named: "uniTrack Light Blue")!, UIColor(named: "uniTrack Light Yellow")!]
        return colors.randomElement()!
    }

}
