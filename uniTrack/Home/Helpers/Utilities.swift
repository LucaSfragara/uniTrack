//
//  Utilities.swift
//  uniTrack
//
//  Created by Luca Sfragara on 20/12/20.
//

import Foundation
import UIKit

class Utilities{
    
    static func createAlertView(title: String, message: String?, completion: @escaping()->())->UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let doneAction = UIAlertAction(title: "Yes", style: .default){action in
            completion()
        }
        alert.addAction(cancelAction)
        alert.addAction(doneAction)
        
        return alert
    }
}