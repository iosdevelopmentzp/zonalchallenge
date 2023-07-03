//
//  StarWarsSpaceSceneUITests.swift
//  StarWarsAPIViewerUITests
//
//  Created by Dmytro Vorko on 03.07.2023.
//

import XCTest

final class StarWarsSpaceSceneUITests: XCTestCase {
    var app: StarWarsApp!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = .init()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func test_screenUIIsValid() throws {
        app.launch()
        
        let button = app.buttons["browsePlanetsButton"]
        
        let isButtonExist = button.waitForExistence(timeout: 5)
        
        XCTAssertTrue(isButtonExist)
        XCTAssertEqual(button.label, "Browse Planets...")
        XCTAssertTrue(app.navigationBars.staticTexts["SWAPI"].exists)
    }
}
