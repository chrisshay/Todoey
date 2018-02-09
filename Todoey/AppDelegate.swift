//
//  AppDelegate.swift
//  Todoey
//
//  Created by Christopher Shayler on 02/02/2018.
//  Copyright © 2018 Christopher Shayler. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        do{
            _ = try Realm()

        }catch{
            print("Error initialising realm \(error)")
        }
        
        
        return true
    }





}

