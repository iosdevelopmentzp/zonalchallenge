//
//  PlanetsViewUITests.swift
//  StarWarsAPIViewerUITests
//
//  Created by Dmytro Vorko on 03.07.2023.
//

import XCTest

final class PlanetsViewUITests: XCTestCase {
    
    private var app: StarWarsApp!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = .init()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testExample() throws {
        app
            .setPlanetsFirstPageRequest(isSuccessful: true)
            .setPlanetsNextPageRequest(isSuccessful: true)
        
        app.launch()

        let button = app.buttons["browsePlanetsButton"]
        let isButtonExist = button.waitForExistence(timeout: 2)
        XCTAssertTrue(isButtonExist, "The browsePlanetsButton should be visible on the screen")
        button.tap()
        
        let nameLabel = app.staticTexts["cellNameLabel_0"]
        XCTAssertTrue(nameLabel.waitForExistence(timeout: 5))
        
        XCTAssertEqual(nameLabel.label, "Tatooine")
        XCTAssertEqual(app.staticTexts["cellPopulationLabel_0"].label, "Population: 200000")
        
        XCTAssertEqual(app.staticTexts["cellNameLabel_1"].label, "Alderaan")
        XCTAssertEqual(app.staticTexts["cellPopulationLabel_1"].label, "Population: 2000000000")
        
        XCTAssertEqual(app.staticTexts["cellNameLabel_2"].label, "Yavin IV")
        XCTAssertEqual(app.staticTexts["cellPopulationLabel_2"].label, "Population: 1000")
        
        XCTAssertEqual(app.staticTexts["cellNameLabel_3"].label, "Hoth")
        XCTAssertEqual(app.staticTexts["cellPopulationLabel_3"].label, "Population: unknown")
        
        XCTAssertTrue(app.navigationBars.staticTexts["Planets"].exists)
    }
}

