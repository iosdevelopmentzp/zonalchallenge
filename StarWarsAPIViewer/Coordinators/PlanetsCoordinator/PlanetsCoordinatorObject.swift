//
//  PlanetsCoordinatorObject.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import SwiftUI

@MainActor
final class PlanetsCoordinatorObject: ObservableObject {
    // MARK: - Properties
    
    @Published var spaceViewModel: StarWarsSpaceViewModel?
    @Published var planetsViewModel: PlanetsViewModel?
    @Published var planetDetailsViewModel: PlanetDetailsViewModel?
    
    // MARK: - Start
    
    func start() {
        spaceViewModel = StarWarsSpaceViewModel(sceneDelegate: self)
    }
}

// MARK: - PlanetsViewSceneDelegate

extension PlanetsCoordinatorObject: StarWarsSpaceViewSceneDelegate {
    func didTapBrowsePlanets() {
        planetsViewModel = PlanetsViewModel(
            useCase: StarWarsUseCase(
                starWarsNetwork: StarWarsNetworkService(
                    client: SwapiClientService(
                        networking: NetworkingService(
                            plugins: [LoggingPlugin()]
                        ),
                        baseURL: "https://swapi.dev/"
                    )
                )
            ),
            sceneDelegate: self
        )
    }
}

// MARK: - PlanetsViewSceneDelegate

extension PlanetsCoordinatorObject: PlanetsViewSceneDelegate {
    func openDetails(for planet: String) {
        planetDetailsViewModel = PlanetDetailsViewModel(
            useCase: StarWarsUseCase(
                starWarsNetwork: StarWarsNetworkService(
                    client: SwapiClientService(
                        networking: NetworkingService(
                            plugins: [LoggingPlugin()]
                        ),
                        baseURL: "https://swapi.dev/"
                    )
                )
            ),
            sceneDelegate: self
        )
    }
}

// MARK: - PlanetDetailsViewSceneDelegate

extension PlanetsCoordinatorObject: PlanetDetailsViewSceneDelegate {
    /* Protocol implementation */
}
