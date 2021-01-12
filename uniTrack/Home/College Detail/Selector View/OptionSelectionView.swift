//
//  OptionSelectionView.swift
//  uniTrack
//
//  Created by Luca Sfragara on 31/12/20.
//

import UIKit

class OptionSelectionView: UIView {


    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var firstView: SelectorSingleView! //safety
    @IBOutlet weak var secondView: SelectorSingleView! //match
    @IBOutlet weak var thirdView: SelectorSingleView! //target
    
    var selectedOption: University.ReachType?{
        didSet{
            switch selectedOption{
            
            case .safety:
                firstView.activate()
                secondView.deactivate()
                thirdView.deactivate()
            case .match:
                firstView.deactivate()
                secondView.activate()
                thirdView.deactivate()
            case .target:
                firstView.deactivate()
                secondView.deactivate()
                thirdView.activate()
            case .none:
                firstView.deactivate()
                secondView.deactivate()
                thirdView.deactivate()
                
            }
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("OptionSelectionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,  .flexibleHeight]
        setupViews()
    }
    
    private func setupViews(){
        
        //first View
        firstView.setup(state: .active, titleForView: "Safety", maskCorners: .left)
        secondView.setup(state: .inactive, titleForView: "Match", maskCorners: .none)
        thirdView.setup(state: .inactive, titleForView: "Target", maskCorners: .right)
    }
}

//MARK: Tap gesture recognizers
extension OptionSelectionView{
    
    @IBAction private func didTapFirstView(_ gestureRecognizer: UITapGestureRecognizer){
        if selectedOption == .safety{
            selectedOption = nil
            return
        }
        selectedOption = .safety

    }
    
    @IBAction private func didTapSecondView(_ gestureRecognizer: UITapGestureRecognizer){
        if selectedOption == .match{
            selectedOption = nil
            return
        }
        selectedOption = .match
    }
    
    @IBAction private func didTapThirdView(_ gestureRecognizer: UITapGestureRecognizer){
        if selectedOption == .target{
            selectedOption = nil
            return
        }
        selectedOption = .target
    }
}

