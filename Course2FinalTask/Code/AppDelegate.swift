//
//  AppDelegate.swift
//  Course2FinalTask
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let dataManager = CoreDataManager(modelName: "Model")
               let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
               let vc = storyboard.instantiateViewController(withIdentifier: Identifier.authenticationViewController) as? AuthenticationViewController
               vc?.dataManager = dataManager
        return true
    }
    

}
