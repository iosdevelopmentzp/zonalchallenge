//
//  StarWarsSpaceViewModel.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import Foundation

@MainActor
protocol StarWarsSpaceViewModelProtocol: ObservableObject {
    func handle(_ event: StarWarsSpaceViewEvent)
}

enum StarWarsSpaceViewEvent {
    case didTapBrowsePlanets
}

@MainActor
final class StarWarsSpaceViewModel: ObservableObject, StarWarsSpaceViewModelProtocol {
    // MARK: - Properties
    
    private weak var sceneDelegate: StarWarsSpaceViewSceneDelegate?
    
    // MARK: - Constructor
    
    init(sceneDelegate: StarWarsSpaceViewSceneDelegate) {
        self.sceneDelegate = sceneDelegate
    }
    
    // MARK: - StarWarsSpaceViewModelProtocol
    
    func handle(_ event: StarWarsSpaceViewEvent) {
        switch event {
        case .didTapBrowsePlanets:
            sceneDelegate?.didTapBrowsePlanets()
        }
    }
}
