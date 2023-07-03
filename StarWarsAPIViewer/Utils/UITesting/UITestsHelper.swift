//
//  UITestsHelper.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 03.07.2023.
//

import Foundation

struct UITestsHelper {
    private struct Constants {
        static let uiTestingLaunchFlag = "-ui-testing"
        
        static let planetsFirstPageRequestKey = "-request-planets-first-page"
        static let planetsNextPageRequestKey = "-request-planets-next-page"
        static let planetDetailsRequestKey = "-request-planet-details"
    }
    
    static var isUITesting: Bool {
        ProcessInfo.processInfo.arguments.contains(Constants.uiTestingLaunchFlag)
    }
    
    #if DEBIG
    static var isPlanetsFirstPageRequestSuccessful: Bool {
        ProcessInfo.processInfo.flag(forKey: Constants.planetsFirstPageRequestKey)
    }
    
    static var isPlanetsNextPageRequestSuccessful: Bool {
        ProcessInfo.processInfo.flag(forKey: Constants.planetsNextPageRequestKey)
    }
    
    static var isPlanetDetailsRequestSuccessful: Bool {
        ProcessInfo.processInfo.flag(forKey: Constants.planetDetailsRequestKey)
    }
    #endif
}

#if DEBUG

private extension ProcessInfo {
    func flag(forKey key: String) -> Bool {
        guard
            let stringFlag = ProcessInfo.processInfo.environment[key],
            let flag = Bool(stringFlag)
        else {
            fatalError("UITesting flag with key \(key) has not been found")
        }
        
        return flag
    }
}
#endif
