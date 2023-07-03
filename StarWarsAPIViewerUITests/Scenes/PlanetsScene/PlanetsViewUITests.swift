//
//  PlanetsViewUITests.swift
//  StarWarsAPIViewerUITests
//
//  Created by Dmytro Vorko on 03.07.2023.
//

import XCTest
@testable import StarWarsAPIViewer

final class PlanetsViewUITests: XCTestCase {
    
    private var app: StarWarsApp!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.setPlanetsFirstPageRequest(isSuccessful: true)
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}

final class StarWarsApp: XCUIApplication {
    private struct Constants {
        static let uiTestingLaunchFlag = "-ui-testing"
        
        static let planetsFirstPageRequestKey = "-request-planets-first-page"
        static let planetsNextPageRequestKey = "-request-planets-next-page"
        static let planetDetailsRequestKey = "-request-planet-details"
    }
    
    override init() {
        super.init()
        launchArguments = [Constants.uiTestingLaunchFlag]
    }
    
    @discardableResult
    func setPlanetsFirstPageRequest(isSuccessful: Bool) -> StarWarsApp {
        launchEnvironment[Constants.planetsFirstPageRequestKey] = String(describing: isSuccessful)
        return self
    }
    
    @discardableResult
    func setPlanetsNextPageRequest(isSuccessful: Bool) -> StarWarsApp {
        launchEnvironment[Constants.planetsNextPageRequestKey] = String(describing: isSuccessful)
        return self
    }
    
    @discardableResult
    func setPlanetDetailsRequest(isSuccessful: Bool) -> StarWarsApp {
        launchEnvironment[Constants.planetDetailsRequestKey] = String(describing: isSuccessful)
        return self
    }
}
