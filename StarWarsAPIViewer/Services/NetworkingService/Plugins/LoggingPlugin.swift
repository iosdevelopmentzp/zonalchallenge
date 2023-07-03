//
//  LoggingPlugin.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import Foundation

/// A logging plugin that conforms to the `NetworkingPluginProtocol`
struct LoggingPlugin: NetworkingPluginProtocol {
    // MARK: - Properties
    
    private let dateFormatter: DateFormatter?
    
    private var dateStringRepresentation: String {
        "Date: \(dateFormatter?.string(from: Date()) ?? "")"
    }
    
    init() {
#if DEBUG
        dateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = .autoupdatingCurrent
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss.SSS"
            return dateFormatter
        }()
#else
        dateFormatter = nil
#endif
    }
    
    // MARK: - NetworkingPluginProtocol
    
#if DEBUG
    /// Prints the upcoming request details.
    /// - Parameters:
    ///   - identifier: The identifier of the request.
    ///   - request: The URLRequest object representing the upcoming request.
    func willStartRequest(identifier: Int, _ request: URLRequest) {
        printUpcomingRequest(request, identifier: identifier)
    }
    
    /// Prints the details of a failed request.
    /// - Parameters:
    ///   - identifier: The identifier of the request.
    ///   - error: The error that occurred during the request.
    ///   - request: The URLRequest object representing the failed request.
    func requestDidFail(identifier: Int, with error: Error, request: URLRequest) {
        printFailedRequest(with: error, request: request, identifier: identifier)
    }
    
    /// Prints the details of a successful request.
    /// - Parameters:
    ///   - identifier: The identifier of the request.
    ///   - request: The URLRequest object representing the successful request.
    ///   - response: The URLResponse object received for the request.
    ///   - data: The response data received for the request.
    func requestDidSucceed(identifier: Int, request: URLRequest, response: URLResponse, data: Data?) {
        printSuccessfulRequest(request: request, response: response, data: data, identifier: identifier)
    }
#else
    func willStartRequest(identifier: Int, _ request: URLRequest) {}
    func requestDidFail(identifier: Int, with error: Error, request: URLRequest) {}
    func requestDidSucceed(identifier: Int, request: URLRequest, response: URLResponse, data: Data?) {}
#endif
    
    // MARK: - Private
    
    private func printUpcomingRequest(_ request: URLRequest, identifier: Int) {
        print("\n\n#################\nRequest(id: \(identifier)) is Starting \n\t\(dateStringRepresentation)")
        
        if let url = request.url?.absoluteString {
            print("URL Path: \n\t\(url)")
        }
        
        if let method = request.httpMethod {
            print("Request Method: \n\t\(method)")
        }
        
        if let bodyData = request.httpBody {
            print("Request Body: \n\(prettyJSON(bodyData))")
        }
        
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("Request Headers:")
            for (key, value) in headers {
                print("\t\(key): \(value)")
            }
        }
        
        print("#################\n\n")
    }
    
    private func printFailedRequest(with error: Error, request: URLRequest, identifier: Int) {
        print("\n\n#################\nRequest(id: \(identifier)) Failed\n\t\(dateStringRepresentation)")
        
        if let url = request.url?.absoluteString {
            print("URL Path: \n\t\(url)")
        }
        
        if let method = request.httpMethod {
            print("Request Method: \n\t\(method)")
        }
        
        if let bodyData = request.httpBody {
            print("Request Body: \n\(prettyJSON(bodyData))")
        }
        
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("Request Headers:")
            for (key, value) in headers {
                print("\t\(key): \(value)")
            }
        }
        
        print("Error: \n\t\(error.localizedDescription)")
        print("#################\n\n")
    }
    
    private func printSuccessfulRequest(
        request: URLRequest,
        response: URLResponse,
        data: Data?,
        identifier: Int
    ) {
        let responseCode = (response as? HTTPURLResponse)?.statusCode
        print("\n\n#################\nResponse on request(id: \(identifier))\n\t\(dateStringRepresentation)\(responseCode.map { "\n\tCODE: \($0)" } ?? "")")
        
        if let url = request.url?.absoluteString {
            print("URL Path: \n\t\(url)")
        }
        
        if let method = request.httpMethod {
            print("Request Method: \n\t\(method)")
        }
        
        if let bodyData = request.httpBody {
            print("Request Body: \n\(prettyJSON(bodyData))")
        }
        
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("Request Headers:")
            for (key, value) in headers {
                print("\t\(key): \(value)")
            }
        }
        
        if let headers = (response as? HTTPURLResponse)?.allHeaderFields as? [String: Any], !headers.isEmpty {
            print("Response Headers:")
            for (key, value) in headers {
                print("\t\(key): \(value)")
            }
        }
        
        if let responseData = data {
            print("Response Body: \n\(prettyJSON(responseData))")
        }
        print("#################\n\n")
    }
    
    private func prettyJSON(_ data: Data) -> String {
        let jsonData: Data
        let jsonIsNotValidMessage = "JSON is not valid"
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        } catch {
            return jsonIsNotValidMessage
        }
        
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            return jsonIsNotValidMessage
        }
        
        return jsonString.replacingOccurrences(of: "\\/", with: "/")
    }
}
