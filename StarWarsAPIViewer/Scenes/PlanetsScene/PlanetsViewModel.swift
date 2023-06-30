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
    case didTapItem(PlanetsViewState.PlanetItem)
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
            
        case .didTapItem(let planetItem):
            debugPrint("Did tap item: \(planetItem)")
            sceneDelegate?.openDetails(for: planetItem.name)
        }
    }
    
    private func setupPaginationObservable() {
        pagination
            .$pageState
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] paginationState in
                guard let self = self else { return }
                if let error = paginationState.error {
                    self.state = .Factory.make(.failedLoading(planets: self.state.planets, error: error))
                } else if paginationState.isLoading {
                    self.state = .Factory.make(.loading(planets: self.state.planets))
                } else if paginationState.isRefreshing {
                    self.state = .Factory.make(.refreshing(planets: self.state.planets))
                } else {
                    self.state = .Factory.make(.loaded(planets: paginationState.elements))
                }
            })
            .store(in: &self.cancellable)
    }
}

