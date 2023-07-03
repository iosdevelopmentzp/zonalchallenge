//
//  MockedError.swift
//  StarWarsAPIViewerTests
//
//  Created by Dmytro Vorko on 03.07.2023.
//

import Foundation

enum MockedError: LocalizedError, Equatable {
    case some
    case localizedDescription(_ description: String)
    
    var errorDescription: String? {
        switch self {
        case .localizedDescription(let description):
            return description
            
        default:
            return String(describing: self)
        }
    }
}
