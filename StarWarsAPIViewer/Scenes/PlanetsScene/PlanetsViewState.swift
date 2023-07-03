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
    /// Represents the refreshing state, indicating that the planets are being refreshed.
    case refreshing(planets: [PlanetItem]?)
    /// Represents the loaded state, indicating that the planets have been successfully loaded.
    case loaded(planets: [PlanetItem])
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
    
    var isIdle: Bool {
        guard case .idle = self else {
            return false
        }
        return true
    }

    var isEmptyList: Bool {
        guard case .emptyList = self else {
            return false
        }
        return true
    }

    var isFailedLoading: Bool {
        guard case .failedLoading = self else {
            return false
        }
        return true
    }

    var isLoaded: Bool {
        guard case .loaded = self else {
            return false
        }
        return true
    }
}

// MARK: - PlanetsViewState.Planet Factory

extension PlanetsViewState.PlanetItem {
    /// Creates a `PlanetsViewState.Planet` instance from a given `Planet` object.
    static func make(from planet: Planet) -> PlanetsViewState.PlanetItem {
        .init(
            id: planet.id,
            name: planet.name,
            population: "Population: \(planet.population)"
        )
    }
}
