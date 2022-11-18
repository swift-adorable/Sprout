//
//  AppDelegate.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureInit()
        
        // Firebase configure
        FirebaseApp.configure()
        
        return true
    }

}

extension AppDelegate {
    fileprivate func configureInit() {
        window?.tintColor = .signature
    }
}
