//
//  PlanetsCoordinatorObject.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import SwiftUI
import Resolver

@MainActor
final class PlanetsCoordinatorObject: ObservableObject {
    // MARK: - Properties
    
    @Published var spaceViewModel: StarWarsSpaceViewModel?
    @Published var planetsViewModel: PlanetsViewModel?
    @Published var planetDetailsViewModel: PlanetDetailsViewModel?
    
    private let resolver: ResolverType
    
    // MARK: - Constructor
    
    init(resolver: ResolverType) {
        self.resolver = resolver
    }
    
    // MARK: - Start
    
    func start() {
        spaceViewModel = StarWarsSpaceViewModel(sceneDelegate: self)
    }
}

// MARK: - PlanetsViewSceneDelegate

extension PlanetsCoordinatorObject: StarWarsSpaceViewSceneDelegate {
    func didTapBrowsePlanets() {
        planetsViewModel = PlanetsViewModel(useCase: resolver.resolve(), sceneDelegate: self)
    }
}

// MARK: - PlanetsViewSceneDelegate

extension PlanetsCoordinatorObject: PlanetsViewSceneDelegate {
    func openPlanetDetails(with planetId: Int) {
        planetDetailsViewModel = PlanetDetailsViewModel(
            planetId: planetId,
            useCase: resolver.resolve(),
            sceneDelegate: self
        )
    }
}

// MARK: - PlanetDetailsViewSceneDelegate

extension PlanetsCoordinatorObject: PlanetDetailsViewSceneDelegate {
    /* Protocol implementation */
}
