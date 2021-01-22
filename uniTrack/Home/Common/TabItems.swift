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
    case settings = "Settings"
    
    var viewController: UIViewController{
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch self {
        case .home:
            let dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardNavVCID") as! UINavigationController
            return dashboardVC
        case .colleges:
            let collegesVC = storyboard.instantiateViewController(withIdentifier: "CollegesNavVCID") as! UINavigationController
            return collegesVC
        case .settings:
            let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsNavVCID") as! UINavigationController
            return settingsVC
        }
    }
    
    var icon: UIImage{
        switch self{
        case .home:
            return UIImage(named: "Home normal")!
        case .colleges:
            return UIImage(named: "Colleges normal")!
        case .settings:
            return UIImage(named: "Settings normal")!
        }
    }
    
    var selectedIcon: UIImage{
        
        switch self{
        case .home:
            return UIImage(named: "Home selected")!
        case .colleges:
            return UIImage(named: "Colleges selected")!
        case .settings:
            return UIImage(named: "Settings selected")!
        }
        
    }
    
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}
