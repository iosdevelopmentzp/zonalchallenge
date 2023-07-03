//
//  PlanetsPage+Fixture.swift
//  StarWarsAPIViewerTests
//
//  Created by Dmytro Vorko on 03.07.2023.
//

@testable import StarWarsAPIViewer

extension PlanetsPage {
    static func fixture(
        next: String? = nil,
        planets: [Planet] = []
    ) -> PlanetsPage {
        PlanetsPage(
            next: next,
            planets: planets
        )
    }
}
