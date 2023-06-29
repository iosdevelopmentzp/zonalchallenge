//
//  AppDelegate.swift
//  StarWarsAPIViewer
//
//  Created by Scott Runciman on 20/07/2021.
//

import SwiftUI

@main
struct StarWarsAPIViewerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainCoordinatorView(object: appDelegate.mainCoordinator)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    let mainCoordinator = MainCoordinatorObject()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        mainCoordinator.start()
        return true
    }
}
