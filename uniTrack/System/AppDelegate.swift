//
//  AppDelegate.swift
//  uniTrack
//
//  Created by Luca Sfragara on 19/10/2020.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var defaults = UserDefaults.standard
    
    var hasLaunchedBefore : Bool?{
        get{
            return defaults.bool(forKey: "hasLaunchedBefore")
        }
        set{
            defaults.setValue(newValue, forKey: "hasLaunchedBefore")
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if hasLaunchedBefore != true{
            //load universities json into coredata
            preloadUniversityData()

        }
        hasLaunchedBefore = true
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func preloadUniversityData(){
        print("preloading data...")
        guard let fileURL = Bundle.main.url(forResource: "data", withExtension: "json") else{
            fatalError("Couldn't fetch the url for the university file")
        }
        
        guard let jsonData = try? String(contentsOf: fileURL).data(using: .utf8) else {return}
        
        //json parsing
        let decoder = JSONDecoder()
        let BackgroundContext = PersistantService.persistentContainer.newBackgroundContext()
        PersistantService.context.automaticallyMergesChangesFromParent = true
        
        BackgroundContext.perform {
            do {
                guard let decodedUniversities = try? decoder.decode(UniversityListFromJSON.self, from: jsonData) else {
                    return
                }
                
                for university in decodedUniversities.universities{
                    
                    let universityObject = UniversityFromData(context: BackgroundContext)
                    universityObject.name = university.name
                    universityObject.telephone = university.telephone
                    universityObject.zip = university.zip
                    universityObject.address = university.address
                    universityObject.population = university.population
                    universityObject.latitude = Double(university.geoPoint!.components(separatedBy: ",")[0]) ?? 0.0
                    universityObject.longitude = Double(university.geoPoint!.components(separatedBy: ",")[1]) ?? 0.0
                    universityObject.city = university.city
                    universityObject.state = university.state
                }
                
                try BackgroundContext.save()
                
            } catch let error {
                print(error.localizedDescription)
            }
 
            
        }
        
    }

}

