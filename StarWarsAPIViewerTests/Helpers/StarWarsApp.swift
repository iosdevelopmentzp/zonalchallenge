//
//  StarWarsApp.swift
//  StarWarsAPIViewerUITests
//
//  Created by Dmytro Vorko on 03.07.2023.
//

import XCTest

final class StarWarsApp: XCUIApplication {
    override init() {
        super.init()
        launchArguments = [ProcessInfoUITestConstants.uiTestingLaunchFlag]
    }
    
    // MARK: - Setup 
    
    @discardableResult
    func setPlanetsFirstPageRequest(isSuccessful: Bool) -> StarWarsApp {
        launchEnvironment[ProcessInfoUITestConstants.planetsFirstPageRequestKey] = String(describing: isSuccessful)
        return self
    }
    
    @discardableResult
    func setPlanetsNextPageRequest(isSuccessful: Bool) -> StarWarsApp {
        launchEnvironment[ProcessInfoUITestConstants.planetsNextPageRequestKey] = String(describing: isSuccessful)
        return self
    }
    
    @discardableResult
    func setPlanetDetailsRequest(isSuccessful: Bool) -> StarWarsApp {
        launchEnvironment[ProcessInfoUITestConstants.planetDetailsRequestKey] = String(describing: isSuccessful)
        return self
    }
}
