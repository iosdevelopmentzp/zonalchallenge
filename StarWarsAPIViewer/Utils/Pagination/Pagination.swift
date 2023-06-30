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
        let isRefreshing: Bool
        let isLoading: Bool
        let error: Error?
        let elements: [Element]
        
        init(isRefreshing: Bool = false, isLoading: Bool = false, error: Error? = nil, elements: [Element] = []) {
            self.isRefreshing = isRefreshing
            self.isLoading = isLoading
            self.error = error
            self.elements = elements
        }
    }
    
    struct PaginationPageElement {
        let nextDependency: PageDependency?
        let elements: [Element]
    }
    
    typealias PageProviderClosure = (PageDependency) async throws -> PaginationPageElement
    
    // MARK: - Properties
    
    private var refreshTask: Task<Void, Never>?
    private var task: Task<Void, Never>?
    private var nextDependency: PageDependency?
    private let pageProvider: PageProviderClosure
    private let inititalDependencyProvider: () -> PageDependency
   
    @Published var pageState: PageState = .init()
    
    // MARK: - Constructor
    
    init(
        pageProvider: @escaping PageProviderClosure,
        inititalDependencyProvider: @escaping () -> PageDependency
    ) {
        self.pageProvider = pageProvider
        self.inititalDependencyProvider = inititalDependencyProvider
    }
    
    func refresh() {
        self.task?.cancel()
        self.task = nil
        
        guard self.refreshTask == nil else {
            return
        }
        self.pageState = .init(isRefreshing: true, elements: self.pageState.elements)
        
        self.refreshTask = Task {
            let result = await Result { try await self.pageProvider(self.inititalDependencyProvider()) }
            guard !Task.isCancelled else { return }
            
            switch result {
            case .success(let pageDependency):
                self.nextDependency = pageDependency.nextDependency
                self.pageState = .init(elements: pageDependency.elements)
            case .failure(let error):
                self.pageState = .init(error: error, elements: self.pageState.elements)
            }
            self.refreshTask = nil
        }
    }
    
    func loadNext() {
        guard self.task == nil, self.refreshTask == nil, let nextDependency = self.nextDependency else {
            return
        }
        
        self.pageState = .init(isLoading: true, elements: self.pageState.elements)
        
        self.task = Task {
            let result = await Result { try await self.pageProvider(nextDependency) }
            guard !Task.isCancelled else { return }
            
            switch result {
            case .success(let pageDependency):
                self.nextDependency = pageDependency.nextDependency
                self.pageState = .init(elements: self.pageState.elements + pageDependency.elements)
                
            case .failure(let error):
                self.pageState = .init(error: error, elements: self.pageState.elements)
            }
            
            self.task = nil
        }
    }
}
