//
//  PlanetsViewSceneDelegateMock.swift
//  StarWarsAPIViewerTests
//
//  Created by Dmytro Vorko on 03.07.2023.
//

@testable import StarWarsAPIViewer

final class PlanetsViewSceneDelegateMock: PlanetsViewSceneDelegate {
    var openPlanetDetailsCallsCount = 0
    var openPlanetDetailsCalled: Bool {
        openPlanetDetailsCallsCount > 0
    }
    var openPlanetDetailsReceivedPlanetId: Int?
    
    func openPlanetDetails(with planetId: Int) {
        openPlanetDetailsCallsCount += 1
        openPlanetDetailsReceivedPlanetId = planetId
    }
}
