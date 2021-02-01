//
//  Extension.swift
//  uniTrack
//
//  Created by Luca Sfragara on 01/02/21.
//

import Foundation

extension String{
    
    func capitalizingFirstLetter() -> String{
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter(){
        self = self.capitalizingFirstLetter()
    }
    
}
