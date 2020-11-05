//
//  DesignableButton.swift
//  todoApp
//
//  Created by Massimiliano Sfragara on 19/05/2020.
//  Copyright © 2020 Sfra.org. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class DesignableButton: UIButton{
    
    @IBInspectable var cornerRadius: Double {
         get {
           return Double(self.layer.cornerRadius)
         }set {
           self.layer.cornerRadius = CGFloat(newValue)
         }
    }
    @IBInspectable var borderWidth: Double {
          get {
            return Double(self.layer.borderWidth)
          }
          set {
           self.layer.borderWidth = CGFloat(newValue)
          }
    }
    @IBInspectable var borderColor: UIColor? {
         get {
            return UIColor(cgColor: self.layer.borderColor!)
         }
         set {
            self.layer.borderColor = newValue?.cgColor
         }
    }
    @IBInspectable var shadowColor: UIColor? {
        get {
           return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
           self.layer.shadowColor = newValue?.cgColor
        }
    }
    @IBInspectable var shadowOpacity: Float {
        get {
           return self.layer.shadowOpacity
        }
        set {
           self.layer.shadowOpacity = newValue
       }
    }
    @IBInspectable var shadowOffset: CGSize{
        get{
            return self.layer.shadowOffset
        }
        set{
            self.layer.shadowOffset = .zero
        }
    }
    
    func disableButton(){
        
        self.isEnabled=false
        self.alpha=0.40
    }
    func enableButton(){
        self.isEnabled=true
        self.alpha=1
    }
    
}
