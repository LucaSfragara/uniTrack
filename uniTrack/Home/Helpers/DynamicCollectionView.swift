//
//  DynamicCollectionView.swift
//  uniTrack
//
//  Created by Luca Sfragara on 17/12/20.
//

import UIKit

class DynamicCollectionView: UICollectionView {
    
        override func layoutSubviews() {
        
            super.layoutSubviews()
            
            if (self.bounds.size.equalTo(self.intrinsicContentSize)) {
                self.invalidateIntrinsicContentSize()
            }
        }
        
        override var intrinsicContentSize: CGSize
        {
            if self.collectionViewLayout.collectionViewContentSize.height < 100{
                return self.collectionViewLayout.collectionViewContentSize
            }else{
                return CGSize(width: self.collectionViewLayout.collectionViewContentSize.width, height: 100.0)
            }
        }
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

