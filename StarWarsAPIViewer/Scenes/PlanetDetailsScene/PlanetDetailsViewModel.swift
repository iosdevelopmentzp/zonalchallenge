//
//  PlanetDetailsViewModel.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 02.07.2023.
//

import SwiftUI

@MainActor
protocol PlanetDetailsViewModelProtocol: ObservableObject {
    var state: PlanetDetailsViewState { get }
    
    func handle(_ event: PlanetDetailsViewEvent)
}

enum PlanetDetailsViewEvent {
    case viewDidLoad
    case didTapRefresh
    case didTapTryAgain
}

@MainActor
final class PlanetDetailsViewModel: ObservableObject, PlanetDetailsViewModelProtocol {
    // MARK: - Properties
    @Published private(set) var state: PlanetDetailsViewState = .idle

    private let useCase: StarWarsUseCaseProtocol
    private weak var sceneDelegate: PlanetDetailsViewSceneDelegate?
    
    // MARK: - Constructor
    
    init(
        useCase: StarWarsUseCaseProtocol,
        sceneDelegate: PlanetDetailsViewSceneDelegate?
    ) {
        self.sceneDelegate = sceneDelegate
        self.useCase = useCase
    }
    
    // MARK: - Functions
    
    func handle(_ event: PlanetDetailsViewEvent) {
        switch event {
        case .viewDidLoad:
            break
                
        case .didTapRefresh, .didTapTryAgain:
            break
        }
    }
}


