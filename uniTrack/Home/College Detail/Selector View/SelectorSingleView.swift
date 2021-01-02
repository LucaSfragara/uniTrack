//
//  SelectorSingleView.swift
//  uniTrack
//
//  Created by Luca Sfragara on 02/01/21.
//

import UIKit

class SelectorSingleView: UIView {

    //TODO: TODO: make text bigger if text is active
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var contentView: UIView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    func activate(){
        
        titleLabel.textColor = UIColor(named: "uniTrack Light Orange")
        contentView.layer.borderColor = UIColor(named: "uniTrack Light Orange")?.cgColor
        contentView.backgroundColor = UIColor(named: "uniTrack Light BG Orange")
    }
    
    func deactivate(){
        titleLabel.textColor = UIColor(named: "uniTrack secondary label color")
        contentView.layer.borderColor = UIColor(named: "uniTrack secondary label color")?.cgColor
        contentView.backgroundColor = UIColor.white
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("OptionSelectionSingleView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,  .flexibleHeight]
    }
    
    func setup(state: ViewState, titleForView title: String, maskCorners: CornersToMask){
    
        contentView.layer.borderWidth = 1.0
        contentView.layer.cornerRadius = 10
        titleLabel.text = title
        
        switch state {
        case .active:
            activate()
        case .inactive:
            deactivate()
        }
        
        switch maskCorners {
        case .left:
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        case .right:
            contentView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        case .none:
            contentView.layer.cornerRadius = 0
        }
        
    }
    
   
}

//MARK: CUSTOM TYPES

extension SelectorSingleView{
    enum ViewState{
        case active
        case inactive
    }
    
    enum CornersToMask{
        case none
        case left
        case right
    }

}

