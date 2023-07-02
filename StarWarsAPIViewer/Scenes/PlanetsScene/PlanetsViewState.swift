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
        let id: Int?
        let name: String
        let population: String
    }
    /// Represents the idle state, indicating no data is currently available.
    case idle
    /// Represents the empty list state, indicating that the list of planets is empty.
    case emptyList
    /// Represents the failed loading state, indicating that an error occurred while loading the planets.
    case failedLoading(errorMessage: String, planets: [PlanetItem]?)
    /// Represents the loading state, indicating that the planets are being loaded.
    case loading(planets: [PlanetItem]?)
    
    case refreshing(planets: [PlanetItem]?)
    /// Represents the loaded state, indicating that the planets have been successfully loaded.
    case loaded(planets: [PlanetItem])
}

// MARK: - Factory

extension PlanetsViewModel {
    enum Event {
        case refreshing
        case loading
        case failedLoading(error: Error)
        case loaded(planets: [Planet])
    }
    
    struct Reducer {
        static func reduce(state currentState: PlanetsViewState, event: Event) -> PlanetsViewState {
            let newState: PlanetsViewState
            
            switch event {
            case .refreshing:
                newState = .refreshing(planets: currentState.planets)
                
            case .loading:
                newState = .loading(planets: currentState.planets)
                
            case .failedLoading(let error):
                newState = .failedLoading(
                    errorMessage: error.localizedDescription,
                    planets: currentState.planets
                )
                
            case .loaded(let planets):
                if planets.isEmpty, currentState.planets.isEmpty {
                    newState = .emptyList
                } else if planets.isEmpty {
                    newState = .loaded(planets: currentState.planets)
                } else if currentState.isRefreshing {
                    newState = .loaded(planets: planets.map(PlanetsViewState.PlanetItem.make(from:)))
                } else {
                    newState = .loaded(planets: currentState.planets + planets.map(PlanetsViewState.PlanetItem.make(from:)))
                }
            }
            
            return newState
        }
    }
}

// MARK: - Computed Properties

extension PlanetsViewState {
    /// Computed property that returns the planets associated with the current state.
    var planets: [PlanetItem] {
        switch self {
        case .failedLoading(_, let planets), .loading(let planets), .refreshing(let planets):
            return planets ?? []
            
        case .loaded(let planets):
            return planets
            
        case .idle, .emptyList:
            return []
        }
    }
    
    var isLoading: Bool {
        guard case .loading = self else {
            return false
        }
        
        return true
    }
    
    var isRefreshing: Bool {
        guard case .refreshing = self else {
            return false
        }
        
        return true
    }
}

// MARK: - PlanetsViewState.Planet Factory

private extension PlanetsViewState.PlanetItem {
    /// Creates a `PlanetsViewState.Planet` instance from a given `Planet` object.
    static func make(from planet: Planet) -> PlanetsViewState.PlanetItem {
        .init(
            id: planet.id,
            name: planet.name,
            population: "Population: \(planet.population)"
        )
    }
}
