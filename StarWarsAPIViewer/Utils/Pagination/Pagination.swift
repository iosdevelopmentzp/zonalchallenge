//
//  Pagination.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import Foundation

protocol PaginationDependency: Equatable {}

/// A pagination utility class for managing paginated data retrieval.
///
/// Use the `Pagination` class to handle pagination logic and state management for fetching paginated data. This class supports async/await syntax and can be used with SwiftUI's `@StateObject` property wrapper.
///
/// - Note: To use `Pagination`, create a dependency conforming to the `PaginationDependency` protocol and provide a closure that retrieves the page elements based on the given dependency.
@MainActor
final class Pagination<PageDependency: PaginationDependency, Element> {
    // MARK: - Nested
    
    struct PageState {
        let isRefreshing: Bool
        let isLoading: Bool
        let error: Error?
        let elements: [Element]?
        
        init(isRefreshing: Bool = false, isLoading: Bool = false, error: Error? = nil, elements: [Element]? = nil) {
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
    
    /// Initializes the `Pagination` instance with the specified page provider and initial dependency provider.
    ///
    /// Use this initializer to create an instance of the `Pagination` class. The page provider closure is responsible for asynchronously retrieving the page elements based on the provided `PageDependency`. The initial dependency provider closure supplies the initial `PageDependency` used for the first page request.
    ///
    /// - Parameters:
    ///   - pageProvider: A closure that takes a `PageDependency` as input and returns an `PaginationPageElement` asynchronously. This closure is responsible for retrieving the page elements.
    ///   - initialDependencyProvider: A closure that provides the initial `PageDependency` used for the first page request.
    init(
        pageProvider: @escaping PageProviderClosure,
        inititalDependencyProvider: @escaping () -> PageDependency
    ) {
        self.pageProvider = pageProvider
        self.inititalDependencyProvider = inititalDependencyProvider
    }
    
    /// Refreshes the paginated data by requesting the first page.
    ///
    /// Use this method to refresh the paginated data by making a new request for the first page. It cancels any ongoing loading tasks and sets the page state to indicate a refreshing state. The `pageProvider` closure is invoked asynchronously with the initial dependency obtained from the `initialDependencyProvider`. Upon completion, the page state is updated based on the result, including the possibility of setting an error if the refresh fails.
    ///
    /// - Note: This method should be called when you want to manually trigger a refresh of the paginated data.
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
    
    /// Loads the next page of paginated data.
    ///
    /// Use this method to load the next page of paginated data. It checks if there are no ongoing tasks for refreshing or loading, and if a `nextDependency` is available. If these conditions are met, the method updates the page state to indicate a loading state, invokes the `pageProvider` closure asynchronously with the `nextDependency`, and updates the page state based on the result. The elements from the loaded page are appended to the existing elements in the page state, and errors are handled accordingly.
    ///
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
                self.pageState = .init(elements: (self.pageState.elements ?? []) + pageDependency.elements)
                
            case .failure(let error):
                self.pageState = .init(error: error, elements: self.pageState.elements)
            }
            
            self.task = nil
        }
    }
}
