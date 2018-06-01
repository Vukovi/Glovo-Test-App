//
//  AppDelegate.swift
//  Glovo
//
//  Created by Vuk Knežević on 6/1/18.
//  Copyright © 2018 Vuk Knežević. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        GMSServices.provideAPIKey("AIzaSyAAk5l473kzZMBpgGSODGm8oL00HjzTYaI")
        GMSPlacesClient.provideAPIKey("AIzaSyAAk5l473kzZMBpgGSODGm8oL00HjzTYaI")
        
        let info = loadInfoDictionary()
        
        let glovoBuilder = GlovoBuilder { (builder) in
            builder.baseUrl = info?["BaseURL"] as? String ?? ""
            builder.countriesEndpoint = info?["CountriesEndpoint"] as? String ?? ""
            builder.citiesEndpoint = info?["CitiesEndpoint"] as? String ?? ""
            builder.mocked = info?["AllowMock"] as? Bool
        }
        
        let glovoConfiguration = GlovoConfiguration(builder: glovoBuilder)
        
        Api.instance.initialize(glovoConfiguration: glovoConfiguration!)
        
        loadSplashScreen()
        
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

    func setRootViewController(rootViewController: UIViewController) {
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
    }
    
    func loadInfoDictionary() -> NSDictionary? {
        if let fileUrl = Bundle.main.url(forResource: "Info", withExtension: "plist"),
            let data = try? Data(contentsOf: fileUrl) {
            if let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? NSDictionary {
                return result
            }
        }
        return nil
    }
    
    func loadSplashScreen() {
        let svc = SplashScreenVC()
        setRootViewController(rootViewController: svc)
    }

}

