//
//  DynamicCollectionView.swift
//  uniTrack
//
//  Created by Luca Sfragara on 17/12/20.
//

import UIKit

class DynamicCollectionView: UICollectionView {
    
    var isDynamicSizeRequired = false
    
    override func layoutSubviews() {
        
            super.layoutSubviews()
            if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
                self.invalidateIntrinsicContentSize()
            }
        
        }
        
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

