//
//  Endpoint.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import Foundation

enum HTTPMethod: String, Equatable {
    case GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS, TRACE, CONNECT
}

/// Represents an endpoint for a network request.
struct Endpoint<T> {
    // MARK: - Properties
    
    /// The path of the endpoint.
    let path: String
    
    /// The HTTP method of the endpoint.
    let httpMethod: HTTPMethod
    
    /// The query items to be included in the URL.
    var queryItems: [URLQueryItem]?
    
    /// The body parameters to be included in the request.
    var body: [String : Any]?

    // MARK: - Constructor
    
    init(
        path: String,
        httpMethod: HTTPMethod,
        queryItems: [URLQueryItem]? = nil,
        body: [String : Any]? = nil
    ) {
        self.path = path
        self.httpMethod = httpMethod
        self.queryItems = queryItems
        self.body = body
    }
}

// MARK: - Endpoint Ext

extension Endpoint {
    /// The body data to be included in the request.
    var bodyData: Data? {
        guard let body = body, !body.isEmpty else { return nil }
        guard let data = try? JSONSerialization.data(withJSONObject: body) else { return nil }
        return data
    }
    
    /// Constructs the URL for the endpoint using the provided base URL.
    /// - Parameter baseURL: The base URL to be used for constructing the full URL.
    /// - Returns: The constructed URL.
    func url(baseURL: String) -> URL? {
        if let queryItems = queryItems {
            var components = URLComponents(string: baseURL + path)
            components?.queryItems = queryItems
            return components?.url
        }
        
        return URL(string: baseURL + path)
    }
    
    /// Constructs a URL request for the endpoint using the provided URL.
    /// - Parameter url: The URL to be used for constructing the request.
    /// - Returns: The constructed URL request.
    func request(url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        
        if let bodyData = bodyData {
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.addValue("Content-Type", forHTTPHeaderField: "application/json")
            }
            
            urlRequest.httpBody = bodyData
        }
        
        return urlRequest
    }
}
