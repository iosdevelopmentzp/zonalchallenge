//
//  PlanetDetailsViewState.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 02.07.2023.
//

import Foundation

enum PlanetDetailsViewState: Hashable {
    struct PlanetItem: Hashable {
        enum Parameter: Hashable, Identifiable {
            case population(String)
            case terrain(String)
            case climate(String)
            case gravity(String)
            case rotationPeriod(String)
            case orbitalPeriod(String)
            
            var id: Int {
                self.hashValue
            }
        }
        
        let name: String
        let parameters: [Parameter]
    }
    
    case idle
    case loading
    case refreshing(PlanetItem)
    case failed(errorMessage: String, PlanetItem?)
    case loaded(PlanetItem)
}

// MARK: - Reducer

extension PlanetDetailsViewModel {
    struct Reducer {
        enum Event {
            case loading
            case refreshing
            case loaded(Planet)
            case failed(Error)
        }
        
        static func reduce(state currentState: PlanetDetailsViewState, event: Event) -> PlanetDetailsViewState {
            let reducedState: PlanetDetailsViewState
            
            switch event {
            case .loading:
                reducedState = .loading
            case .refreshing:
                if let item = currentState.planetItem {
                    reducedState = .refreshing(item)
                } else {
                    assertionFailure("Expecting not nil planet item for refreshing event. Current state: \(currentState)")
                    reducedState = currentState
                }
                
            case .loaded(let planet):
                reducedState = .loaded(PlanetDetailsViewState.PlanetItem(planet: planet))
                
            case .failed(let error):
                reducedState = .failed(errorMessage: error.localizedDescription, currentState.planetItem)
            }
            
            debugPrint("REduced: \(reducedState)")
            return reducedState
        }
    }
}

extension PlanetDetailsViewState {
    var planetItem: PlanetItem? {
        switch self {
        case .idle, .loading:
            return nil
        case .failed(_, let planetItem):
            return planetItem
        case .loaded(let planetItem), .refreshing(let planetItem):
            return planetItem
        }
    }
    
    var isRefreshing: Bool {
        guard case .refreshing = self else {
            return false
        }
        return true
    }
    
    var isLoading: Bool {
        guard case .loading = self else {
            return false
        }
        return true
    }
}

private extension PlanetDetailsViewState.PlanetItem {
    init(planet: Planet) {
        self = .init(
            name: planet.name,
            parameters: Array<Parameter?>([
                .population(planet.population),
                .terrain(planet.terrain),
                planet.climate.map { Parameter.climate($0) },
                planet.gravity.map { Parameter.gravity($0) },
                planet.rotationPeriod.map { Parameter.rotationPeriod(String($0)) },
                planet.orbitalPeriod.map { Parameter.orbitalPeriod(String($0)) }
            ]).compactMap { $0 }
        )
    }
}

extension PlanetDetailsViewState.PlanetItem.Parameter {
    var localized: (title: String, value: String) {
        switch self {
        case .population(let value):
            return ("Population", value)
        case .terrain(let value):
            return ("Terrain", value)
        case .climate(let value):
            return ("Climate", value)
        case .gravity(let value):
            return ("Gravity", value)
        case .rotationPeriod(let value):
            return ("Rotation Period", value)
        case .orbitalPeriod(let value):
            return ("Orbital Period", value)
        }
    }
}
