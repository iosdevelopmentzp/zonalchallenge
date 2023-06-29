//
//  Pagination.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import Foundation

protocol PaginationDependency: Equatable {}

@MainActor
final class Pagination<PageDependency: PaginationDependency, Element> {
    // MARK: - Nested
    
    struct PageState {
        public let isLoading: Bool
        public let error: Error?
        public let elements: [Element]
    }
    
    struct PaginationPageElement {
        let nextDependency: PageDependency?
        let elements: [Element]
    }
    
    typealias PageProviderClosure = (PageDependency) async throws -> PaginationPageElement
    
    // MARK: - Properties
    
    private var task: Task<Void, Never>?
    private var nextDependency: PageDependency?
    private let pageProvider: PageProviderClosure
    private let inititalDependencyProvider: () -> PageDependency
   
    @Published var pageState: PageState
    
    // MARK: - Constructor
    
    init(
        pageProvider: @escaping PageProviderClosure,
        inititalDependencyProvider: @escaping () -> PageDependency
    ) {
        self.pageProvider = pageProvider
        self.inititalDependencyProvider = inititalDependencyProvider
        self.pageState = .init(isLoading: false, error: nil, elements: [])
    }
    
    func refresh() {
        self.task?.cancel()
        self.pageState = .init(isLoading: true, error: nil, elements: self.pageState.elements)
        
        self.task = Task {
            let result = await Result { try await self.pageProvider(self.inititalDependencyProvider()) }
            guard !Task.isCancelled else { return }
            
            switch result {
            case .success(let pageDependency):
                self.nextDependency = pageDependency.nextDependency
                self.pageState = .init(isLoading: false, error: nil, elements: pageDependency.elements)
            case .failure(let error):
                self.pageState = .init(isLoading: false, error: error, elements: self.pageState.elements)
            }
            self.task = nil
        }
    }
    
    func loadNext() {
        guard self.task == nil, let nextDependency = self.nextDependency else {
            return
        }
        
        self.pageState = .init(isLoading: true, error: nil, elements: self.pageState.elements)
        
        self.task = Task {
            let result = await Result { try await self.pageProvider(nextDependency) }
            guard !Task.isCancelled else { return }
            
            switch result {
            case .success(let pageDependency):
                self.nextDependency = pageDependency.nextDependency
                self.pageState = .init(
                    isLoading: false,
                    error: nil,
                    elements: self.pageState.elements + pageDependency.elements
                )
                
            case .failure(let error):
                self.pageState = .init(isLoading: false, error: error, elements: self.pageState.elements)
            }
            
            self.task = nil
        }
    }
}
