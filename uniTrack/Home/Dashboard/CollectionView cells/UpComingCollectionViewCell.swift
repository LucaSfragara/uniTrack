//
//  UpComingCollectionViewCell.swift
//  uniTrack
//
//  Created by Luca Sfragara on 27/10/2020.
//

import UIKit
import M13Checkbox

//FIXME: FIXME: change name of cell class
class UpComingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var universityNameLabel: UILabel!
    @IBOutlet weak private var taskLabel: StrikethroughLabel!
    @IBOutlet weak private var checkBox: M13Checkbox!
    
    private var task: Task?
    private var titleAttributeString: NSMutableAttributedString?
    
    func setup(task: Task){
        
        self.task = task
        setupCheckbox()
        taskLabel.text = task.title
        universityNameLabel.text = task.university.name
        
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.init(named: "uniTrack Blue")
        
        titleAttributeString =  NSMutableAttributedString(string: task.title)
        
        if task.isCompleted {
            checkBox.setCheckState(.checked, animated: false)
            titleAttributeString!.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, titleAttributeString!.length))
            self.taskLabel.attributedText = titleAttributeString
            
        }else{
            checkBox.setCheckState(.unchecked, animated: false)
            checkBox.isSelected = false
            self.taskLabel.text = task.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setupCheckbox(){
        
        checkBox.addTarget(self, action: #selector(didPressCheckbox(sender:)), for: .valueChanged)
        
        checkBox.checkedValue = true
        checkBox.uncheckedValue = false
        
        checkBox.boxType = .circle
        checkBox.markType = .checkmark
        checkBox.checkmarkLineWidth = 3.0
        
        checkBox.cornerRadius = 4
        checkBox.boxLineWidth = 2.0
        checkBox.backgroundColor = UIColor(named: "uniTrack Blue")
        checkBox.layer.borderColor = UIColor.white.cgColor
        
        checkBox.tintColor = UIColor.white
        checkBox.secondaryCheckmarkTintColor = UIColor(named: "uniTrack Blue")
        checkBox.stateChangeAnimation = .fill
        
    }
    
    @objc private func didPressCheckbox(sender: M13Checkbox){
        
        titleAttributeString!.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, titleAttributeString!.length))
        self.taskLabel.attributedText = titleAttributeString

        switch sender.value as! Bool{
        case true:
            self.taskLabel.strikeThroughText()
            task?.isCompleted = true
            
        case false:
            self.taskLabel.hideStrikeTextLayer()
            task?.isCompleted = false
        }
        DataManager.shared.saveToPersistantStore()
    }
    
    
}
