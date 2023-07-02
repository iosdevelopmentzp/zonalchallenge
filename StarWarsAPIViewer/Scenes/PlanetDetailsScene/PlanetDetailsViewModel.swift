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
        case .viewDidLoad, .didTapTryAgain:
            requestDetails(isRefreshing: false)
                
        case .didTapRefresh:
            requestDetails(isRefreshing: true)
        }
    }
    
    // MARK: - Private
    
    private func requestDetails(isRefreshing: Bool) {
        task?.cancel()
        
        self.state = Self.Reducer.reduce(state: self.state, event: isRefreshing ? .refreshing : .loading)
        
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
