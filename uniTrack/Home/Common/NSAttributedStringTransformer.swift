//
//  NSAttributedStringTransformer.swift
//  uniTrack
//
//  Created by Luca Sfragara on 05/02/21.
//

import UIKit
import CoreData
@objc(NSAttributedStringTransformer)
class NSAttributedStringTransformer: NSSecureUnarchiveFromDataTransformer {
        override class var allowedTopLevelClasses: [AnyClass] {
                return super.allowedTopLevelClasses + [NSAttributedString.self]
        }
}
