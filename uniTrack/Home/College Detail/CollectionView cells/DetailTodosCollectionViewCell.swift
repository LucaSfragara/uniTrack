//
//  DetailTodosCollectionViewCell.swift
//  uniTrack
//
//  Created by Luca Sfragara on 13/12/20.
//

import UIKit
import M13Checkbox

class DetailTodosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: DesignableView!
    @IBOutlet weak var titleLabel: StrikethroughLabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var checkbox: M13Checkbox!
    
    var titleAttributeString: NSMutableAttributedString?
    
    var task: Task?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCheckbox()
        mainView.backgroundColor = UIColor(named: "uniTrack Light Blue")
    }
    
    func setup(task: Task){ //replace parameters with task object
        self.task = task
        self.titleLabel.text = task.title
        self.secondaryLabel.text = task.text
        titleAttributeString =  NSMutableAttributedString(string: task.title)
        
        if task.isCompleted {
            checkbox.setCheckState(.checked, animated: false)
            titleAttributeString!.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, titleAttributeString!.length))
            self.titleLabel.attributedText = titleAttributeString
            
        }else{
            checkbox.setCheckState(.unchecked, animated: false)
            checkbox.isSelected = false
            self.titleLabel.text = task.title
        }
        

    }
    @objc private func didPressCheckbox(sender: M13Checkbox){
        
        titleAttributeString!.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, titleAttributeString!.length))
        self.titleLabel.attributedText = titleAttributeString

        switch sender.value as! Bool{
        case true:
            self.titleLabel.strikeThroughText()
            task?.isCompleted = true
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
        case false:
            self.titleLabel.hideStrikeTextLayer()
            task?.isCompleted = false
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        }
        DataManager.shared.saveToPersistantStore()
    }
    
    
    private func setupCheckbox(){
        
        checkbox.addTarget(self, action: #selector(didPressCheckbox(sender:)), for: .valueChanged)
        
        checkbox.checkedValue = true
        checkbox.uncheckedValue = false
        
        checkbox.boxType = .square
        checkbox.markType = .checkmark
        checkbox.checkmarkLineWidth = 2.0
        
        checkbox.cornerRadius = 4
        checkbox.boxLineWidth = 2.0
        checkbox.backgroundColor = UIColor(named: "uniTrack Light Blue")
        
        checkbox.stateChangeAnimation = .stroke
        
    }
    
    private func randomColor() -> UIColor{
        let colors = [UIColor(named: "uniTrack Light Green")!, UIColor(named: "uniTrack Light Blue")!, UIColor(named: "uniTrack Light Yellow")!]
        return colors.randomElement()!
    }

}
