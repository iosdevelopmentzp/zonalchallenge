//
//  PlanetsViewModel.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import SwiftUI
import Combine

@MainActor
protocol PlanetsViewModelProtocol: ObservableObject {
    var state: PlanetsViewState { get }
    
    func handle(_ event: PlanetsViewEvent)
}

enum PlanetsViewEvent {
    case viewDidLoad
    case didTapRefresh
    case didTapTryAgain
    case didReachBottom
    case didTapItem(id: Int)
}

@MainActor
final class PlanetsViewModel: ObservableObject, PlanetsViewModelProtocol {
    // MARK: - Nested
    
    private struct PlanetsPagingDependency: PaginationDependency {
        let nextURL: String?
        let isFirstPage: Bool
    }
    
    // MARK: - Properties
    
    @Published private(set) var state: PlanetsViewState = .idle

    private let useCase: StarWarsUseCaseProtocol
    private weak var sceneDelegate: PlanetsViewSceneDelegate?
    private var cancellable: [AnyCancellable] = []
    
    private lazy var pagination = Pagination<PlanetsPagingDependency, Planet>(
        pageProvider: { [weak self] dependency in
            guard let self = self else { return .init(nextDependency: nil, elements: []) }
            
            let page: PlanetsPage
            if dependency.isFirstPage {
                page = try await self.useCase.planetsFirstPage()
            } else if let nextURL = dependency.nextURL, !nextURL.isEmpty {
                page = try await self.useCase.planetsNextPage(url: nextURL)
            } else {
                return .init(
                    nextDependency: nil,
                    elements: []
                )
            }
            
            return .init(
                nextDependency: page.next.map { .init(nextURL: $0, isFirstPage: false) },
                elements: page.planets
            )
        },
        inititalDependencyProvider: {
            .init(nextURL: nil, isFirstPage: true)
        }
    )
    
    // MARK: - Constructor
    
    init(
        useCase: StarWarsUseCaseProtocol,
        sceneDelegate: PlanetsViewSceneDelegate?
    ) {
        self.sceneDelegate = sceneDelegate
        self.useCase = useCase
    }
    
    // MARK: - Functions
    
    func handle(_ event: PlanetsViewEvent) {
        switch event {
        case .viewDidLoad:
            setupPaginationObservable()
            pagination.refresh()
                
        case .didTapRefresh, .didTapTryAgain:
            pagination.refresh()
            
        case .didReachBottom:
            pagination.loadNext()
            
        case .didTapItem(let id):
            sceneDelegate?.openPlanetDetails(with: id)
        }
    }
    
    // MARK: - Private
    
    private func setupPaginationObservable() {
        pagination
            .$pageState
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] paginationState in
                guard let self = self else { return }
                
                if let error = paginationState.error {
                    self.state = Self.Reducer.reduce(state: self.state, event: .failedLoading(error: error))
                } else if paginationState.isLoading {
                    self.state = Self.Reducer.reduce(state: self.state, event: .loading)
                } else if paginationState.isRefreshing {
                    self.state = Self.Reducer.reduce(state: self.state, event: .refreshing)
                } else if let elements = paginationState.elements {
                    self.state = Self.Reducer.reduce(state: self.state, event: .loaded(planets: elements))
                } else {
                    self.state = Self.Reducer.reduce(state: self.state, event: .idle)
                }
            })
            .store(in: &self.cancellable)
    }
}

// MARK: - Reducer

private extension PlanetsViewModel {
    enum Event {
        case idle
        case refreshing
        case loading
        case failedLoading(error: Error)
        case loaded(planets: [Planet])
    }
    
    struct Reducer {
        static func reduce(state currentState: PlanetsViewState, event: Event) -> PlanetsViewState {
            let newState: PlanetsViewState
            
            switch event {
            case .idle:
                newState = .idle
                
            case .refreshing:
                newState = .refreshing(planets: currentState.planets)
                
            case .loading:
                newState = .loading(planets: currentState.planets)
                
            case .failedLoading(let error):
                newState = .failedLoading(
                    errorMessage: error.localizedDescription,
                    planets: currentState.planets
                )
                
            case .loaded(let planets):
                if planets.isEmpty, currentState.planets.isEmpty {
                    newState = .emptyList
                } else if planets.isEmpty {
                    newState = .loaded(planets: currentState.planets)
                } else {
                    newState = .loaded(planets: planets.map(PlanetsViewState.PlanetItem.make(from:)))
                }
            }
            
            return newState
        }
    }
}
