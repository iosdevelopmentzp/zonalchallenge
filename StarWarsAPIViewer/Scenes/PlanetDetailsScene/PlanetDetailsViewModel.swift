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

    private let planetId: Int
    private let useCase: StarWarsUseCaseProtocol
    private weak var sceneDelegate: PlanetDetailsViewSceneDelegate?
    private var task: Task<Void, Never>?
    
    // MARK: - Constructor
    
    init(
        planetId: Int,
        useCase: StarWarsUseCaseProtocol,
        sceneDelegate: PlanetDetailsViewSceneDelegate?
    ) {
        self.planetId = planetId
        self.sceneDelegate = sceneDelegate
        self.useCase = useCase
    }
    
    // MARK: - Functions
    
    func handle(_ event: PlanetDetailsViewEvent) {
        switch event {
        case .viewDidLoad, .didTapTryAgain, .didTapRefresh:
            requestDetails()
        }
    }
    
    // MARK: - Private
    
    private func requestDetails() {
        task?.cancel()
        
        self.state = Self.Reducer.reduce(state: self.state, event: state.planetItem == nil ? .loading : .refreshing)
        
        task = Task {
            let result = await Result(throwingAsync: {
                try await self.useCase.planetDetails(id: self.planetId)
            })
            
            guard !Task.isCancelled else { return }
            
            switch result {
            case .success(let details):
                self.state = Self.Reducer.reduce(state: self.state, event: .loaded(details))
                
            case .failure(let error):
                self.state = Self.Reducer.reduce(state: self.state, event: .failed(error))
            }
        }
    }
}

// MARK: - Reducer

private extension PlanetDetailsViewModel {
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
            
            return reducedState
        }
    }
}
