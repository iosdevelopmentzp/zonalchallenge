//
//  Planet+Fixture.swift
//  StarWarsAPIViewerTests
//
//  Created by Dmytro Vorko on 03.07.2023.
//

@testable import StarWarsAPIViewer

extension Planet {
    static func fixture(
        url: String = "",
        name: String = "",
        terrain: String = "",
        population: String = "",
        climate: String? = nil,
        gravity: String? = nil,
        rotationPeriod: String? = nil,
        orbitalPeriod: String? = nil
    ) -> Planet {
        Planet(
            url: url,
            name: name,
            terrain: terrain,
            population: population,
            climate: climate,
            gravity: gravity,
            rotationPeriod: rotationPeriod,
            orbitalPeriod: orbitalPeriod
        )
    }
}
