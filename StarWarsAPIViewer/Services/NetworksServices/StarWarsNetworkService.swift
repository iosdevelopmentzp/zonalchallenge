//
//  StarWarsNetworkService.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import Foundation

protocol StarWarsNetworkServiceProtocol {
    func loadPlanetsFirstPage() async throws -> PlanetsPageDTO
    func loadPlanetsNextPage(url: String) async throws -> PlanetsPageDTO
}

/// A network service for loading planet data.
final class StarWarsNetworkService: StarWarsNetworkServiceProtocol {
    // MARK: - Nested types
    
    /// Available API endpoints.
    private enum API {
        case planetsFirstPage
        case nextPage(url: String)

        var path: String {
            switch self {
            case .planetsFirstPage:
                return "api/planets"
            
            case .nextPage(let url):
                let urlInstance = URL(string: url)
                var urlComponents = urlInstance.flatMap {
                    URLComponents(url: $0, resolvingAgainstBaseURL: true)
                }
                urlComponents?.scheme = nil
                urlComponents?.host = nil
                var path = urlComponents?.string ?? ""
                if path.hasPrefix("/") {
                    path = String(path.dropFirst())
                }
                return path
            }
        }
    }

    /// API endpoints for different operations.
    private enum APIEndpoint<T> {
        case planetsFirstPage
        case planetsNextPage(url: String)
        
        /// The corresponding `Endpoint` for the endpoint.
        var endpoint: Endpoint<T> {
            switch self {
            case .planetsFirstPage:
                return .init(
                    path: API.planetsFirstPage.path,
                    httpMethod: .GET
                )
                
            case .planetsNextPage(let url):
                return .init(
                    path: API.nextPage(url: url).path,
                    httpMethod: .GET
                )
            }
        }
    }
    
    // MARK: - Properties
    
    private let client: SwapiClientServiceProtocol
    
    // MARK: - Constructor
    
    /// Initializes the `PlanetsNetworkService` with the specified client.
    /// - Parameter client: The client service for making network requests.
    init(client: SwapiClientServiceProtocol) {
        self.client = client
    }
    
    // MARK: - PlanetsNetworkServiceProtocol
    
    /// Loads the first planets page asynchronously.
    /// - Returns: A `PlanetsPageDTO` object representing the loaded planet data.
    func loadPlanetsFirstPage() async throws -> PlanetsPageDTO {
        try await client.request(APIEndpoint<PlanetsPageDTO>.planetsFirstPage.endpoint)
    }
    
    /// Loads the next planets page asynchronously.
    /// - Returns: A `PlanetsPageDTO` object representing the loaded planet data.
    func loadPlanetsNextPage(url: String) async throws -> PlanetsPageDTO {
        try await client.request(APIEndpoint<PlanetsPageDTO>.planetsNextPage(url: url).endpoint)
    }
}
