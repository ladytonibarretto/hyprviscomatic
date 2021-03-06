//
//  AppDelegate.swift
//  Reseller
//
//  Created by Lady Toni Barretto on 10/17/16.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var token: String?
    var username: String?
    var cartItems: [NativeItem] = []
    var branchList: [JSON] = []
    var purchaseList: [JSON] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().barTintColor = UIColor(red: 1.0/255.0, green: 52.0/255.0, blue: 106.0/255.0, alpha: 1.0)
         UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)]
        GMSServices.provideAPIKey("AIzaSyAJ_gsmf9CE3L9haiysU0zV7P61ROE0Hq0")
        GMSPlacesClient.provideAPIKey("AIzaSyAJ_gsmf9CE3L9haiysU0zV7P61ROE0Hq0")
        
        // Override point for customization after application launch.
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
        // Saves changes in the application's managed object context before the application terminates.
    }
    
}

let ad = UIApplication.shared.delegate as! AppDelegate
var cartItems = [NativeItem]()


