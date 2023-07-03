//
//  ProcessInfoUITestConstants.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 03.07.2023.
//

import Foundation

#if DEBUG
struct ProcessInfoUITestConstants {
    static let uiTestingLaunchFlag = "-ui-testing"
    
    static let planetsFirstPageRequestKey = "-request-planets-first-page"
    static let planetsNextPageRequestKey = "-request-planets-next-page"
    static let planetDetailsRequestKey = "-request-planet-details"
}
#endif
