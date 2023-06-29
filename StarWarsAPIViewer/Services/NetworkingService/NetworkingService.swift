//
//  NetworkingService.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

/// The protocol that defines a network session capable of loading data asynchronously for a given URL request.
protocol NetworkSessionProtocol {
    func loadData(for request: URLRequest) async throws -> (data: Data, urlResponse: URLResponse)
}

/* Extension of URLSession to conform to the NetworkSessionProtocol. */
extension URLSession: NetworkSessionProtocol {
    func loadData(for request: URLRequest) async throws -> (data: Data, urlResponse: URLResponse) {
        try await self.data(for: request)
    }
}

/// Protocol defining the contract for a networking service.
protocol NetworkingServiceProtocol {
    func loadData(_ request: URLRequest) async throws -> Data
}

/// The protocol for networking plugins that can hook into the networking service at various stages.
protocol NetworkingPluginProtocol {
    /// Called when a request is about to start.
    /// - Parameter request: The URLRequest that is about to start.
    func willStartRequest(identifier: Int, _ request: URLRequest)
    
    /// Called when a request fails.
    /// - Parameters:
    ///   - error: The error that occurred during the request.
    ///   - request: The URLRequest that failed.
    func requestDidFail(identifier: Int, with error: Error, request: URLRequest)
    
    /// Called when a request succeeds.
    /// - Parameters:
    ///   - request: The URLRequest that succeeded.
    ///   - response: The URLResponse received from the request.
    ///   - data: The data received from the request, if any.
    func requestDidSucceed(identifier: Int, request: URLRequest, response: URLResponse, data: Data?)
}

/// An enumeration representing networking errors that can occur during the networking process.
enum NetworkingError: Error {
    case unableToGetResponseCode
    case errorStatusCode(Int, Data)
}

/// The `NetworkingService` class is responsible for handling network requests and loading data asynchronously. It conforms to the `NetworkSessionProtocol`.
final class NetworkingService: NSObject, NetworkingServiceProtocol {
    // MARK: - Properties
    
    private let _session: NetworkSessionProtocol?
    
    private lazy var session: NetworkSessionProtocol = _session ?? {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = .init(memoryCapacity: 0, diskCapacity: 0)
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    private let plugins: [NetworkingPluginProtocol]
    
    // MARK: - Constructor
    
    init(
        session: NetworkSessionProtocol? = nil,
        plugins: [NetworkingPluginProtocol] = []
    ) {
        self.plugins = plugins
        _session = session
    }
    
    // MARK: - NetworkingServiceProtocol
    
    func loadData(_ request: URLRequest) async throws -> Data {
        let response: (data: Data, urlResponse: URLResponse)
        
        response = try await session.loadData(for: request)
        
        guard let httpUrlResponse = response.urlResponse as? HTTPURLResponse else {
            throw NetworkingError.unableToGetResponseCode
        }
        
        switch httpUrlResponse.statusCode {
        case 200...399:
            return response.data
        case 400...499:
            throw NetworkingError.errorStatusCode(httpUrlResponse.statusCode, response.data)
        case 500...599:
            throw NetworkingError.errorStatusCode(httpUrlResponse.statusCode, response.data)
        default:
            throw NetworkingError.errorStatusCode(httpUrlResponse.statusCode, response.data)
        }
    }
}

// MARK: - URLSessionDataDelegate

extension NetworkingService: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest) async -> (URLSession.DelayedRequestDisposition, URLRequest?) {
        if let request = task.originalRequest {
            plugins.forEach {
                $0.willStartRequest(identifier: task.taskIdentifier, request)
            }
        }
        return (.continueLoading, nil)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let request = dataTask.originalRequest, let response = dataTask.response else {
            return
        }
        plugins.forEach {
            $0.requestDidSucceed(
                identifier: dataTask.taskIdentifier,
                request: request,
                response: response,
                data: data
            )
        }
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let request = task.originalRequest else {
            return
        }
        plugins.forEach {
            $0.requestDidFail(
                identifier: task.taskIdentifier,
                with: error ?? NSError(domain: "urlSessiontaskdidCompleteWithError", code: -100),
                request: request
            )
        }
    }
}

