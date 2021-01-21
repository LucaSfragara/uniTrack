//
//  TabItems.swift
//  uniTrack
//
//  Created by Luca Sfragara on 21/01/21.
//

import Foundation
import UIKit

enum TabItem: String, CaseIterable{
    case home = "Home"
    case colleges = "My Colleges"
    
    var viewController: UIViewController{
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch self {
        case .home:
            let dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardNavVCID") as! UINavigationController
            return dashboardVC
        case .colleges:
            let collegesVC = storyboard.instantiateViewController(withIdentifier: "CollegesNavVCID") as! UINavigationController
            return collegesVC
           
        }
    }
    
    var icon: UIImage{
        switch self{
        case .home:
            return UIImage(named: "Home normal")!
        case .colleges:
            return UIImage(named: "Colleges normal")!
        }
    }
    
    var displayTitle: String {
            return self.rawValue.capitalized(with: nil)
        }
}
