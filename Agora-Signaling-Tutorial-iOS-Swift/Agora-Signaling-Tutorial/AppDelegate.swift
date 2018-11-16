//
//  AppDelegate.swift
//  Agora-Signaling-Tutorial
//
//  Created by ZhangJi on 29/11/2017.
//  Copyright © 2017 ZhangJi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LogWriter.initLogWriter()
        return true
    }
}

