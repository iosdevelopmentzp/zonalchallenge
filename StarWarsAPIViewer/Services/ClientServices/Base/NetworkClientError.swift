//
//  NetworkClientError.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import Foundation

/// Represents the possible errors that can occur in the Client.
enum NetworkClientError: LocalizedError {
    /// The URL provided for the network request is invalid.
    case invalidURL
    
    /// An error occurred while decoding JSON data.
    case jsonDecoding(error: Error)
    
    /// The response data is nil.
    case nilData
    
    /// The server returned a bad request (HTTP status code 400) with optional response data.
    case badRequest(data: Data?)
    
    /// The request requires authentication and the provided credentials are unauthorized (HTTP status code 401) with optional response data.
    case unauthorized(data: Data?)
    
    /// The server rejected the request due to insufficient permissions (HTTP status code 403) with optional response data.
    case forbidden(data: Data?)
    
    /// The requested resource could not be found (HTTP status code 404) with optional response data.
    case notFound(data: Data?)
    
    /// The server returned an error with a status code in the range 400-499 (excluding 400) with optional response data.
    case error400(_ code: Int, data: Data?)
    
    /// The server encountered an internal error (HTTP status code 500) with optional response data.
    case serverError(data: Data?)
    
    /// The server returned an error with a status code in the range 500-599 (excluding 500) with optional response data.
    case error500(_ code: Int, data: Data?)
    
    /// An unknown error occurred.
    case unknown
}
