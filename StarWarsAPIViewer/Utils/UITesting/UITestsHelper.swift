//
//  UITestsHelper.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 03.07.2023.
//

import Foundation

/// Helper functions related to UI testing.
struct UITestsHelper {
    static var isUITesting: Bool {
        ProcessInfo.processInfo.arguments.contains(ProcessInfoUITestConstants.uiTestingLaunchFlag)
    }
    
#if DEBUG
    static var isPlanetsFirstPageRequestSuccessful: Bool {
        ProcessInfo.processInfo.environmentFlag(forKey: ProcessInfoUITestConstants.planetsFirstPageRequestKey)
    }
    
    static var isPlanetsNextPageRequestSuccessful: Bool {
        ProcessInfo.processInfo.environmentFlag(forKey: ProcessInfoUITestConstants.planetsNextPageRequestKey)
    }
    
    static var isPlanetDetailsRequestSuccessful: Bool {
        ProcessInfo.processInfo.environmentFlag(forKey: ProcessInfoUITestConstants.planetDetailsRequestKey)
    }
#endif
}

private extension ProcessInfo {
    func environmentFlag(forKey key: String) -> Bool {
        guard let stringFlag = ProcessInfo.processInfo.environment[key] else {
            fatalError("ProcessInfo string flag key \"\(key)\" has not been found. Environments: \(ProcessInfo.processInfo.environment)")
        }
        
        guard let flag = Bool(stringFlag) else {
            fatalError("ProcessInfo value \"\(stringFlag)\" is not bool convertible")
        }
        return flag
    }
}
