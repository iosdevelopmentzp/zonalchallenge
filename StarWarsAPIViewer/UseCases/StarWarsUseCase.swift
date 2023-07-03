//
//  StarWarsUseCase.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import Foundation

protocol StarWarsUseCaseProtocol {
    func planetsFirstPage() async throws -> PlanetsPage
    func planetsNextPage(url: String) async throws -> PlanetsPage
    func planetDetails(id: Int) async throws -> Planet
}

final class StarWarsUseCase: StarWarsUseCaseProtocol {
    // MARK: - Properties
    
    private let starWarsNetwork: StarWarsNetworkServiceProtocol
    
    // MARK: - Constructor
    
    init(starWarsNetwork: StarWarsNetworkServiceProtocol) {
        self.starWarsNetwork = starWarsNetwork
    }
    
    // MARK: - StarWarsUseCaseProtocol
    
    func planetsFirstPage() async throws -> PlanetsPage {
        .init(planetPage: try await starWarsNetwork.loadPlanetsFirstPage())
    }
    
    func planetsNextPage(url: String) async throws -> PlanetsPage {
        .init(planetPage: try await starWarsNetwork.loadPlanetsNextPage(url: url))
    }
    
    func planetDetails(id: Int) async throws -> Planet {
        .init(planet: try await starWarsNetwork.loadPlanetDetails(id: id))
    }
}

// MARK: - PlanetsPage Constructor

private extension PlanetsPage {
    init(planetPage: PlanetsPageDTO) {
        self = .init(next: planetPage.next, planets: planetPage.planets.map(Planet.init(planet:)))
    }
}

private extension Planet {
    init(planet: PlanetDTO) {
        self = Planet(
            url: planet.url,
            name: planet.name,
            terrain: planet.terrain,
            population: planet.population,
            climate: planet.climate,
            gravity: planet.gravity,
            rotationPeriod: planet.rotationPeriod,
            orbitalPeriod: planet.orbitalPeriod
        )
    }
}
