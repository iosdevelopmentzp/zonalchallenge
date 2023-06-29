//
//  SwapiClientService.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import Foundation

protocol SwapiClientServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint<T>) async throws -> T
}

/// A client service that makes network requests and handles decoding of responses.
final class SwapiClientService: SwapiClientServiceProtocol {
    // MARK: - Properties
    
    private let networking: NetworkingServiceProtocol
    private let baseURL: String
    private let decoder: JSONDecoder
    
    // MARK: - Constructor
    
    /// Initializes the `SwapiClientService` with the specified dependencies.
    /// - Parameters:
    ///   - networking: The networking service for sending network requests.
    ///   - baseURL: The base URL for the requests.
    ///   - decoder: The JSON decoder for decoding the responses. Default is `SwapiDecoder`.
    init(
        networking: NetworkingServiceProtocol,
        baseURL: String,
        decoder: JSONDecoder = SwapiDecoder()
    ) {
        self.networking = networking
        self.baseURL = baseURL
        self.decoder = decoder
    }
    
    // MARK: - Functions
    
    /// Sends a network request to the specified endpoint and returns the decoded response.
    /// - Parameters:
    ///   - endpoint: The endpoint representing the network request.
    /// - Returns: The decoded response of type `T`.
    /// - Throws: An error of type `SwapiClientError` if the request fails or encounters an error.
    func request<T: Decodable>(_ endpoint: Endpoint<T>) async throws -> T {
        guard let url = endpoint.url(baseURL: baseURL) else {
            throw NetworkClientError.invalidURL
        }

        let request = endpoint.request(url: url)
        
        do {
            let data = try await networking.loadData(request)
            return try decoder.decode(T.self, from: data)
        } catch NetworkingError.unableToGetResponseCode {
            throw NetworkClientError.unknown
        } catch NetworkingError.errorStatusCode(let code, let data) {
            switch code {
            case 400: throw NetworkClientError.badRequest(data: data)
            case 401: throw NetworkClientError.unauthorized(data: data)
            case 403: throw NetworkClientError.forbidden(data: data)
            case 404: throw NetworkClientError.notFound(data: data)
            case 402, 405..<500: throw NetworkClientError.error400(code, data: data)
            case 500: throw NetworkClientError.serverError(data: data)
            case 501..<600: throw NetworkClientError.error500(code, data: data)
            default: throw NetworkClientError.unknown
            }
        } catch {
            throw NetworkClientError.unknown
        }
    }
}

/// A custom JSON decoder with specific configurations.
final class SwapiDecoder: JSONDecoder {
    override init() {
        super.init()
        self.keyDecodingStrategy = .convertFromSnakeCase
    }
}
