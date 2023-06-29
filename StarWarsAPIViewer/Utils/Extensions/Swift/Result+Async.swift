//
//  Result+Async.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import Foundation

extension Result where Failure == any Error {
    init(throwingAsync closure: @escaping () async throws -> Success) async {
        do {
            let value = try await closure()
            self = .success(value)
        } catch {
            self = .failure(error)
        }
    }
}
