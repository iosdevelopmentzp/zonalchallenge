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
    case failed(PlanetItem?)
    case loaded(PlanetItem)
}

// MARK: - Reducer

extension PlanetDetailsViewModel {
    struct Reducer {
        enum Event {
            case loading
            case refreshing
            case loaded(Planet)
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
            }
            
            return reducedState
        }
    }
}

extension PlanetDetailsViewState {
    var planetItem: PlanetItem? {
        switch self {
        case .idle, .loading, .refreshing:
            return nil
        case .failed(let planetItem):
            return planetItem
        case .loaded(let planetItem):
            return planetItem
        }
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
