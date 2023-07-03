//
//  AppDelegate.swift
//  StarWarsAPIViewer
//
//  Created by Scott Runciman on 20/07/2021.
//

import SwiftUI
import Resolver

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
    private let resolver: ResolverType = Resolver()
    lazy var mainCoordinator = MainCoordinatorObject(resolver: resolver)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard NSClassFromString("XCTest") == nil else {
            return true
        }
        
        resolver.setupDependencies()
        mainCoordinator.start()
        
        return true
    }
}
