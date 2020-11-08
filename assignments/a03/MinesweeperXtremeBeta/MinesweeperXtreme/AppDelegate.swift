//
//  AppDelegate.swift
//  MinesweeperXtreme
//
// Harrison Yelton (hayelton@iu.edu) and Louis Labuzienski (llabuzie@iu.edu)
// Submitted 6/16/2020 11:59

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let ourModel = OurModel()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
            let fm = FileManager.default
            let modelUrl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let arr = try fm.contentsOfDirectory(at: modelUrl, includingPropertiesForKeys: nil)
            try arr.forEach {
                if($0.lastPathComponent == "saveData.plist") {
                    let file = modelUrl.appendingPathComponent("saveData.plist")
                    let data = try Data(contentsOf:file)
                    let model = try PropertyListDecoder().decode(OurModel.self, from: data)
                    self.ourModel.difficulty = model.difficulty
                    self.ourModel.statValues = model.statValues
                    self.ourModel.numBombs = model.numBombs
                    self.ourModel.numFlags = model.numFlags
                    self.ourModel.side = model.side
                    self.ourModel.tiles = model.tiles
                }
            }
        } catch {
            print("Error Loading Save")
            self.ourModel.populateBoard()
            print(self.ourModel.tiles)
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


}

