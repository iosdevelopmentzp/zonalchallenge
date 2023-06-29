//
//  PlanetsViewState.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import SwiftUI

/// Represents the different states of the PlanetsView
enum PlanetsViewState: Hashable {
    struct PlanetItem: Hashable {
        let name: String
        let population: String
    }
    // Represents the idle state, indicating no data is currently available.
    case idle
    /// Represents the empty list state, indicating that the list of planets is empty.
    case emptyList
    /// Represents the failed loading state, indicating that an error occurred while loading the planets.
    case failedLoading(errorMessage: String, planets: [PlanetItem]?)
    /// Represents the loading state, indicating that the planets are being loaded.
    case loading(planets: [PlanetItem]?)
    /// Represents the loaded state, indicating that the planets have been successfully loaded.
    case loaded(planets: [PlanetItem])
}

// MARK: - Factory

extension PlanetsViewState {
    /// A factory class for creating instances of `PlanetsViewState`.
    struct Factory {
        enum InputDataConditions {
            case loading(previousState: PlanetsViewState)
            case failedLoading(previousState: PlanetsViewState, error: Error)
            case loaded(previousState: PlanetsViewState, newPlanets: [Planet])
        }
        
        static func make(_ dataConditions: InputDataConditions) -> PlanetsViewState {
            switch dataConditions {
            case .loading(let previousState):
                return .loading(planets: previousState.planets)
                
            case .failedLoading(let previousState, let error):
                return .failedLoading(
                    errorMessage: error.localizedDescription,
                    planets: previousState.planets
                )
                
            case .loaded(let previousState, let newPlanets):
                let mappedPlanets = newPlanets.map(PlanetItem.make(from:))
                let allPlanets = (previousState.planets ?? []) + mappedPlanets
                guard !allPlanets.isEmpty else {
                    return .emptyList
                }
                
                return .loaded(planets: allPlanets)
            }
        }
    }
}

// MARK: - Computed Properties

extension PlanetsViewState {
    /// Computed property that returns the planets associated with the current state.
    var planets: [PlanetItem]? {
        switch self {
        case .failedLoading(_, let planets), .loading(let planets):
            return planets
            
        case .loaded(let planets):
            return planets
            
        case .idle, .emptyList:
            return nil
        }
    }
}

// MARK: - PlanetsViewState.Planet Factory

private extension PlanetsViewState.PlanetItem {
    /// Creates a `PlanetsViewState.Planet` instance from a given `Planet` object.
    static func make(from planet: Planet) -> PlanetsViewState.PlanetItem {
        .init(
            name: planet.name,
            population: "Population: \(planet.population)"
        )
    }
}
