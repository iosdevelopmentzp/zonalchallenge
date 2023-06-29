//
//  PlanetsViewModel.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import SwiftUI

@MainActor
protocol PlanetsViewModelProtocol: ObservableObject {
    var state: PlanetsViewState { get }
    
    func handle(_ event: PlanetsViewEvent)
}

enum PlanetsViewEvent {
    case viewDidLoad
    case didTapRefresh
    case didTapTryAgain
    case didTapItem(PlanetsViewState.PlanetItem)
}

@MainActor
final class PlanetsViewModel: ObservableObject, PlanetsViewModelProtocol {
    // MARK: - Properties
    
    @Published private(set) var state: PlanetsViewState = .idle
    @Published private(set) var isRefreshing = false
    @Published private(set) var isConnectionAvailable = false

    private weak var sceneDelegate: PlanetsViewSceneDelegate?
    private var task: Task<(), Never>?
    
    // MARK: - Constructor
    
    init(sceneDelegate: PlanetsViewSceneDelegate?) {
        self.sceneDelegate = sceneDelegate
    }
    
    // MARK: - Functions
    
    func handle(_ event: PlanetsViewEvent) {
        switch event {
        case .viewDidLoad:
            refreshPlanets()
                
        case .didTapRefresh, .didTapTryAgain:
            refreshPlanets()
            
        case .didTapItem(let planet):
            sceneDelegate?.openDetails(for: planet.name)
        }
    }
    
    private func refreshPlanets() {
        
    }
}

