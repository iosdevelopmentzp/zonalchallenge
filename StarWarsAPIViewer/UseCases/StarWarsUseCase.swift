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
}

// MARK: - PlanetsPage Constructor

extension PlanetsPage {
    init(planetPage: PlanetsPageDTO) {
        self = .init(next: planetPage.next, planets: planetPage.planets.map {
            Planet(name: $0.name, terrain: $0.terrain, population: $0.population)
        })
    }
}
