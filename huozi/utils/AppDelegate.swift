//
//  AppDelegate.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/17.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit
import SideMenuSwift
import Instabug

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let instabugToken = "fa6757d944ea488d1c91f2babeed4099"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configureSideMenu()
        // Initialize Instabug
        Instabug.start(withToken: instabugToken, invocationEvents: .none)
        Instabug.sessionProfilerEnabled = false
        Instabug.autoScreenRecordingEnabled = false
        Instabug.setPushNotificationsEnabled(false)
        Instabug.setLocale(.chineseSimplified)
        BugReporting.invocationOptions = [.emailFieldOptional, .commentFieldRequired]
        // Sync user data
        NSUbiquitousKeyValueStore.default.synchronize()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func applicationDidFinishLaunching(_ application: UIApplication) {
        
    }
    
    private func configureSideMenu() {
        SideMenuController.preferences.basic.menuWidth = 240
        SideMenuController.preferences.basic.statusBarBehavior = .slide
    }
}

