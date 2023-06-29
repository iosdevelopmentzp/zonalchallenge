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
    
    @Published var planetsViewModel: PlanetsViewModel?
    
    // MARK: - Start
    
    func start() {
        planetsViewModel = .init(sceneDelegate: self)
    }
}

// MARK: - PlanetsViewSceneDelegate

extension PlanetsCoordinatorObject: PlanetsViewSceneDelegate {
    func openDetails(for planet: String) {
        // TODO: - Open Details
    }
}
