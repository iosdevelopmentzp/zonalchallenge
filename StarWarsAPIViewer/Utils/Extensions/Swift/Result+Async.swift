//
//  Result+Async.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import Foundation

extension Result where Failure == any Error {
    /// A convenience initializer for creating a `Result` asynchronously from a throwing closure.
    ///
    /// Use this initializer to create a `Result` from an asynchronous throwing closure. The closure is invoked asynchronously using `await` and captures the success value or any thrown error. The initializer then constructs a `Result` instance with the captured value or error, automatically inferring the `Success` and `Failure` types.
    ///
    /// - Parameters:
    ///   - throwingAsync: An asynchronous throwing closure that produces a `Success` value. Any thrown errors are captured and treated as the `Failure` type.
    init(throwingAsync closure: @escaping () async throws -> Success) async {
        do {
            let value = try await closure()
            self = .success(value)
        } catch {
            self = .failure(error)
        }
    }
}
